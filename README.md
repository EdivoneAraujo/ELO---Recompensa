# ELO — Economia do Futuro com ERC-20

Projeto do Trabalho Prático de Blockchain: criação de uma moeda ERC-20 para recompensas acadêmicas.

## 1. Proposta

O **ELO (ELO)** representa uma pontuação/token de incentivo. A instituição pode recompensar alunos por participação, projetos, atividades e contribuições.

## 2. Especificações

- **Nome:** Elo
- **Símbolo:** ELO
- **Padrão:** ERC-20
- **Decimals:** 18
- **Supply inicial:** 1.000.000 ELO
- **Supply máximo:** 10.000.000 ELO
- **Limite por recompensa:** 1.000 ELO

## 3. Segurança

A versão 2.0 separa responsabilidades:

### Administrador — `DEFAULT_ADMIN_ROLE`
Pode:
- adicionar recompensadores;
- remover recompensadores;
- pausar o contrato;
- despausar o contrato.

### Recompensador — `REWARDER_ROLE`
Pode:
- executar `concederElo()`.

### Aluno
Pode:
- receber ELO;
- transferir ELO;
- usar `approve` e `transferFrom` conforme o padrão ERC-20.

**Importante:** o aluno não possui permissão para criar ELO.

## 4. Proteções implementadas

1. **Supply máximo:** nunca podem existir mais de 10 milhões de ELO.
2. **Limite por recompensa:** uma chamada não pode conceder mais de 1.000 ELO.
3. **Controle por função:** apenas `REWARDER_ROLE` pode conceder recompensas.
4. **Administração separada:** somente `DEFAULT_ADMIN_ROLE` gerencia os recompensadores.
5. **Pausa de emergência:** o administrador pode interromper operações que alteram saldos.
6. **Validação de entradas:** endereço, quantidade e motivo são validados.
7. **Auditoria:** recompensas geram eventos com quem concedeu, quem recebeu, quantidade e motivo.
8. **Sem mint público:** não existe função aberta para qualquer usuário criar tokens.

## 5. Estrutura

```text
ELO_ERC20_V2_Seguro/
├── README.md
├── LICENSE
├── contracts/
│   └── ELO.sol
└── docs/
    ├── GUIA_DE_USO.md
    └── DEPLOY_REMIX.md
```

## 6. Deploy no Remix

1. Abra o Remix.
2. Crie `ELO.sol` dentro de `contracts/`.
3. Cole o código deste projeto.
4. Use o compilador Solidity `0.8.20`.
5. Instale/importe OpenZeppelin conforme o Remix resolver os imports.
6. Em **Deploy & Run Transactions**, selecione a rede Testnet.
7. No construtor, informe a carteira que será o administrador.
8. Faça o deploy.
9. Copie o endereço do contrato.
10. Atualize os comentários de endereço no topo de `ELO.sol`.

## 7. Roteiro de demonstração

### Teste 1 — aluno tentando criar tokens
Troque a conta do Remix para uma carteira sem `REWARDER_ROLE` e tente `concederElo()`.

**Resultado esperado:** transação revertida por falta de permissão.

### Teste 2 — administrador cadastra recompensador
Com a conta administradora:

```text
adicionarRecompensador(enderecoDoRecompensador)
```

### Teste 3 — recompensador concede ELO
Troque para a conta autorizada:

```text
concederElo(
  enderecoDoAluno,
  100000000000000000000,
  "Participação no projeto"
)
```

O valor acima representa **100 ELO**, porque o token usa 18 casas decimais.

### Teste 4 — limite de recompensa
Tente conceder mais de 1.000 ELO em uma única chamada.

**Resultado esperado:** transação revertida.

### Teste 5 — pausa
Administrador:

```text
pausar()
```

Depois tente uma `transfer`.

**Resultado esperado:** transação revertida.

### Teste 6 — retomada
Administrador:

```text
despausar()
```

A transferência deve voltar a funcionar.

## 8. Entrega

Antes de enviar:
- [ ] código compilando;
- [ ] contrato implantado na Testnet;
- [ ] endereço preenchido em `ELO.sol`;
- [ ] testes de segurança realizados;
- [ ] README revisado;
- [ ] guia de `transfer` e `approve` revisado;
- [ ] evidências do Remix/Explorer separadas para apresentação.
