# Bootrap via Bittorrent

Downloading a significant portion of the Bitcoin blockchain over bittorrent saves *a lot* of time.

## Example Invocation

    docker run --volumes-from=bitcoind-data --rm -p 6881:6881 -p 6882:6882 kylemanna/bitcoind btc_bootstrap

## Optional Arguments

* `--gpg-check` will use the GPG signed magnet link instead of the torrent file
* `--custom-torrent` followed by a path/URL to a torrent file or a magnet link will use it instead of default

