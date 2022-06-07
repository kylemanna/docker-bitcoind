local utils = import 'utils.jsonnet';
local repo = 'docker-bitcoind';
[{
  kind: 'pipeline',
  name: repo,
  trigger: utils.default_trigger,
  volumes: utils.volumes(repo),
  steps:  utils.default_publish(repo) + [utils.default_slack],
}] + utils.default_secrets
