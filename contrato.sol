// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/*
 * ELO (ELO) — ERC-20 | Valorizando o Desempenho Acadêmico
 *
 * CARTEIRA ADMINISTRADORA (OWNER/DEPLOYER):
 * 0xbc8d9D0b395ff9282Bef5387aba88c5E3c60420A
 *
 * CONTRACT: 0x72B38AbdC5Fddc58d3477D41C83ea74C6483535F
 * Segurança e Regras:
 * - Supply inicial fixo: 1.000.000 ELO (emitidos para o Administrador).
 * - Supply máximo absoluto: 10.000.000 ELO.
 * - Limite por recompensa: 1.000 ELO por transação.
 * - Somente REWARDER_ROLE pode conceder recompensas.
 * - Somente DEFAULT_ADMIN_ROLE pode gerenciar papéis e pausar o contrato.
 * - Proibida auto-recompensa (recompensador não pode enviar ELO para si mesmo).
 * - Pausable para resposta a incidentes e validações rígidas de entrada.
 */

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/utils/Pausable.sol";

contract ELO is ERC20, AccessControl, Pausable {

    // Papel autorizado a conceder recompensas aos alunos.
    bytes32 public constant REWARDER_ROLE = keccak256("REWARDER_ROLE");

    // Constantes do token (18 casas decimais)
    uint256 public constant INITIAL_SUPPLY = 1_000_000 * 10 ** 18;
    uint256 public constant MAX_SUPPLY = 10_000_000 * 10 ** 18;
    uint256 public constant MAX_REWARD_PER_TX = 1_000 * 10 ** 18;

    // Controle estatístico do total de recompensas recebidas por aluno
    mapping(address => uint256) public totalRecompensasRecebidas;

    // Eventos para auditoria no Explorer
    event RecompensaConcedida(address indexed recompensador,address indexed aluno,uint256 quantidade,string motivo);
    event RecompensadorAdicionado(address indexed conta);
    event RecompensadorRemovido(address indexed conta);
    event ContratoPausado(address indexed administrador);
    event ContratoDespausado(address indexed administrador);

    constructor(address administrador) ERC20("Elo", "ELO") {
        require(administrador != address(0), "Administrador invalido");

        // Concede ao criador os papéis de Administrador e Recompensador
        _grantRole(DEFAULT_ADMIN_ROLE, administrador);
        _grantRole(REWARDER_ROLE, administrador);

        // O supply inicial de 1 milhão de tokens vai direto para o administrador
        _mint(administrador, INITIAL_SUPPLY);
    }

    /**
     * @notice Concede tokens ELO a um aluno como recompensa.
     * @dev Restrito a contas com a role REWARDER_ROLE.
     */
    function concederElo(address aluno,uint256 quantidade,string calldata motivo) external onlyRole(REWARDER_ROLE) whenNotPaused {
        require(aluno != address(0), "Aluno invalido");
        require(aluno != msg.sender, "Nao e permitido recompensar a si mesmo");
        require(quantidade > 0, "Quantidade deve ser maior que zero");
        require(quantidade <= MAX_REWARD_PER_TX, "Recompensa acima do limite");
        require(totalSupply() + quantidade <= MAX_SUPPLY, "Supply maximo excedido");
        require(bytes(motivo).length > 0 && bytes(motivo).length <= 280, "Motivo invalido ou muito longo");

        totalRecompensasRecebidas[aluno] += quantidade;
        _mint(aluno, quantidade);

        emit RecompensaConcedida(msg.sender, aluno, quantidade, motivo);
    }

    /**
     * @notice Adiciona uma nova conta com permissão de conceder recompensas.
     */
    function adicionarRecompensador(address conta) external onlyRole(DEFAULT_ADMIN_ROLE) {
        require(conta != address(0), "Conta invalida");
        _grantRole(REWARDER_ROLE, conta);
        emit RecompensadorAdicionado(conta);
    }

    /**
     * @notice Remove a permissão de recompensa de uma conta.
     */
    function removerRecompensador(address conta) external onlyRole(DEFAULT_ADMIN_ROLE) {
        require(conta != address(0), "Conta invalida");
        _revokeRole(REWARDER_ROLE, conta);
        emit RecompensadorRemovido(conta);
    }

    /**
     * @notice Pausa todas as transferências e emissões em caso de emergência.
     */
    function pausar() external onlyRole(DEFAULT_ADMIN_ROLE) {
        _pause();
        emit ContratoPausado(msg.sender);
    }

    /**
     * @notice Despausa o contrato restabelecendo a operação normal.
     */
    function despausar() external onlyRole(DEFAULT_ADMIN_ROLE) {
        _unpause();
        emit ContratoDespausado(msg.sender);
    }

    /**
     * @dev Hook interno que centraliza as transferências e respeita o estado de pausa.
     */
    function _update(address from, address to, uint256 value) internal override whenNotPaused {
        super._update(from, to, value);
    }
}