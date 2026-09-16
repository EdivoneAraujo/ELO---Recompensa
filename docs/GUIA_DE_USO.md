# Guia de Uso — ELO

## `transfer`

Transfere ELO diretamente para outra carteira.

Exemplo conceitual:

```text
transfer(carteiraDoAluno, 50 ELO)
```

Como o ERC-20 usa 18 casas decimais, no Remix 50 ELO deve ser informado como:

```text
50000000000000000000
```

## `approve`

Autoriza outra carteira/contrato a gastar uma quantidade específica de ELO em nome do proprietário.

Exemplo:

```text
approve(carteiraAutorizada, 100 ELO)
```

Depois da aprovação, o saldo continua pertencendo ao proprietário até que uma operação `transferFrom` seja realizada.

## `allowance`

Consulta quanto uma carteira autorizada ainda pode gastar em nome de outra.

```text
allowance(dono, autorizado)
```

## `transferFrom`

Usado pela carteira/contrato que recebeu aprovação para movimentar os tokens autorizados.

Fluxo:

```text
Aluno
  ↓
approve()
  ↓
Carteira/serviço autorizado
  ↓
transferFrom()
  ↓
Outro endereço
```

## `concederElo`

É a função especial do projeto.

Somente uma conta com `REWARDER_ROLE` pode executá-la:

```text
concederElo(aluno, quantidade, motivo)
```

O contrato verifica:
- endereço válido;
- quantidade maior que zero;
- máximo de 1.000 ELO por operação;
- supply máximo de 10 milhões;
- motivo não vazio;
- contrato não pausado;
- permissão `REWARDER_ROLE`.

## Controle de acesso

O administrador utiliza:

```text
adicionarRecompensador(endereco)
removerRecompensador(endereco)
```

E, em caso de emergência:

```text
pausar()
despausar()
```

## Mensagem para apresentação

> “O diferencial do ELO é que a criação de novas unidades não fica aberta aos alunos. O contrato utiliza controle de acesso por funções: o administrador define quem pode recompensar e somente os recompensadores autorizados conseguem executar o mint de ELO. Além disso, existe supply máximo, limite por recompensa, pausa de emergência e eventos para auditoria.”
