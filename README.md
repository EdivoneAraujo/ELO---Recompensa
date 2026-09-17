# 🎓 Token ELO (ELO) — Valorizando o Desempenho Acadêmico

O **ELO** é um token de recompensa educacional baseado no padrão **ERC-20**, desenvolvido em Solidity com suporte das bibliotecas OpenZeppelin. O objetivo do projeto é gamificar a participação e o engajamento dos alunos, permitindo que professores e administradores concedam tokens por mérito acadêmico ou comportamental, e que os alunos possam resgatá-los por benefícios escolares.

---

## 🛠️ Tecnologias Utilizadas

* **Solidity (`^0.8.20`)**: Linguagem dos contratos inteligentes.
* **OpenZeppelin Contracts**: Implementações padrões para segurança (`ERC20`, `AccessControl`, `Pausable`).
* **Ethers.js (v6)**: Integração Web3 para comunicação entre a interface HTML/JS e a blockchain.
* **Tailwind CSS**: Estilização responsiva do painel de controle.
* **Remix IDE & MetaMask**: Compilação, deploy e interação na rede de testes **Sepolia**.

---

## 📜 Regras de Negócio e Segurança

* **Supply Inicial**: `1.000.000 ELO` emitidos para o endereço do Administrador no deploy.
* **Supply Máximo**: Limite absoluto de `10.000.000 ELO`.
* **Limite por Recompensa**: Máximo de `1.000 ELO` por transação.
* **Controle de Acesso (`AccessControl`)**:
  * `DEFAULT_ADMIN_ROLE`: Gerencia papéis de acesso e possui permissão para pausar/despausar o contrato.
  * `REWARDER_ROLE`: Autorizado a emitir novas recompensas aos alunos.
* **Mecanismo de Resgate**: Ao trocar o token por um benefício, os tokens do aluno são permanentemente queimados (`_burn`).
* **Proteções**: Anti auto-recompensa (o recompensador não pode enviar tokens para si mesmo) e suporte ao módulo `Pausable` para emergências.

---

## 🚀 Como Executar o Projeto

### 1. Compilação e Deploy no Remix IDE

1. Abra o [Remix IDE](https://remix.ethereum.org/).
2. Crie um arquivo chamado `ELO.sol` e cole o código do contrato inteligente.
3. Em **Solidity Compiler**, selecione a versão `0.8.20` ou superior e clique em **Compile ELO.sol**.
4. Em **Deploy & Run Transactions**:
   * Selecione o ambiente **Injected Provider - MetaMask** (certifique-se de estar na rede **Sepolia**).
   * No campo `Deploy`, insira o endereço da sua carteira administradora como parâmetro do construtor.
   * Clique em **Transact** e confirme na MetaMask.
5. Copie o **endereço do contrato gerado**.

### 2. Configuração do Front-end (`index.html`)

1. Abra o arquivo `index.html`.
2. Localize a constante `CONTRACT_ADDRESS` no código JavaScript e substitua pelo endereço copiado:

  ```javascript

  const CONTRACT_ADDRESS = "0x0361Ad563E8054D140A024AEc69d502388073FeC";

---

### 3. Arquitetura dos arquivos

1. Abra o arquivo `index.html` em qualquer navegador web.

## 📁 Estrutura de Arquivos

```text
├── ELO.sol        # Contrato Inteligente ERC-20 em Solidity
├── index.html     # Painel de Controle (HTML5 + Tailwind CSS + Ethers.js v6)
└── README.md      # Documentação do projeto
```

---

## 🛠️ Como Usar a Interface Web

1. **Conectar Carteira:** Clique em **Conectar MetaMask** e certifique-se de estar conectado na rede **Sepolia**.
2. **Conceder Recompensa** (Apenas contas com `REWARDER_ROLE`):
   * Insira o endereço do aluno (`0x...`).
   * Informe a quantidade de ELO e o motivo da recompensa.
   * Clique em **Enviar Recompensa** e confirme a transação.
3. **Resgatar Benefício** (Alunos):
   * Informe a quantidade de ELO necessária e o nome do benefício (ex: *Ponto extra na prova*).
   * Clique em **Resgatar Benefício** para confirmar a queima dos tokens.

---

## 🔍 Guia Prático das Funções Padrão ERC-20 (transfer e approve)

Para interagir diretamente com o contrato através do Remix IDE ou de outras carteiras/scripts, utilize os conceitos das funções padrão do ERC-20:

1. Função transfer (Enviar Tokens)
Utilizada para transferir tokens ELO diretamente da sua carteira para a carteira de outro usuário (por exemplo, um colega).

Parâmetros:

to (address): O endereço da carteira de destino (ex: 0x...).

value (uint256): A quantidade de tokens a ser enviada (lembrando de multiplicar pelas casas decimais, utilizando parseUnits(quantidade, 18) no Ethers.js ou adicionando 18 zeros caso chame direto no Remix em wei).

Como executar no Remix: Expanda o contrato implantado, localize a função transfer, preencha o campo to com o endereço do destinatário e o campo value com a quantidade desejada, depois clique em Transact.
2. Função approve (Autorizar Gastos)
Utilizada para autorizar que um terceiro (como um contrato inteligente de marketplace escolar ou outra conta) gaste uma quantidade específica de tokens em seu nome.

Parâmetros:

spender (address): O endereço autorizado a movimentar os tokens.

value (uint256): O limite máximo de tokens que o spender pode gastar da sua conta.

Como executar no Remix: Localize a função approve, insira o endereço do spender e a quantidade autorizada (value), e clique em Transact para confirmar a permissão na MetaMask.
