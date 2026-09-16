# Deploy e Testes no Remix

## 1. Compilar

- Abra o arquivo `contracts/ELO.sol`.
- Compiler: Solidity `0.8.20`.
- Clique em **Compile ELO.sol**.
- Confirme que não existem erros.

## 2. Deploy

No construtor:

```text
administrador = endereço da carteira institucional/admin
```

Faça o deploy conectado à Testnet escolhida.

## 3. Depois do deploy

Copie o endereço do contrato e atualize:

```solidity
// Endereço do contrato: [COLE_AQUI_O_ENDERECO]
// Explorer: [COLE_AQUI_O_LINK_DO_EXPLORER]
```

## 4. Configurar recompensador

Com a conta administradora:

```text
adicionarRecompensador(ENDERECO_RECOMPENSADOR)
```

Depois confirme:

```text
hasRole(REWARDER_ROLE, ENDERECO_RECOMPENSADOR)
```

O valor deve ser `true`.

## 5. Testar recompensa autorizada

Troque a conta do Remix para o recompensador e execute:

```text
concederElo(
    ENDERECO_ALUNO,
    100000000000000000000,
    "Participação acadêmica"
)
```

Isso concede 100 ELO.

## 6. Testar bloqueio

Troque para uma conta que não tenha `REWARDER_ROLE`.

Tente executar `concederElo`.

**Esperado:** revert por falta de autorização.

## 7. Testar limite

Tente conceder:

```text
1001000000000000000000
```

**Esperado:** revert porque ultrapassa 1.000 ELO.

## 8. Testar pausa

Com administrador:

```text
pausar()
```

Depois tente `transfer`.

**Esperado:** revert.

Finalize com:

```text
despausar()
```

## 9. Evidências recomendadas

Para a apresentação, registre capturas de:
- compilação sem erros;
- deploy na Testnet;
- endereço do contrato;
- `hasRole` retornando `true`;
- recompensa realizada;
- tentativa não autorizada revertida;
- tentativa acima do limite revertida;
- transferência bloqueada durante pausa.
