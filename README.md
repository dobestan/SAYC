# SAYC

## Test on localhost

```shell
$ npx hardhat node
```

```shell
$ npx hardhat deploy
```

## Create Souls

```shell
$ npx hardhat run scripts/events/listen_registers.js
$ npx hardhat run scripts/create_souls.js 
```

## Worker: How off-chain operation works?

Worker and `MatchRequest` Event, `MatchRequestCallback` Function Call is key idea for off-chain matching operation.

1. Worker listen to `MatchRequest` events.
2. When `MatchRequest` event is triggered, worker calls `MatchRequestCallback` function with valid souls(=matching candidates)
3. `MatchRequestCallback` gets souls from off-chain(worker), and then we can create matches on-chain.

```shell
$ npx hardhat run scripts/workers/match.js
```

```shell
$ npx hardhat run scripts/events/listen_match_requests.js
$ npx hardhat run scripts/create_match_requests.js
```
