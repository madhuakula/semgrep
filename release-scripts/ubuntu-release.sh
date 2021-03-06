#!/bin/bash
set -e

echo "here's some help"
ls
echo "---------"
sudo apt-get install -y --no-install-recommends libcurl4-openssl-dev libexpat1-dev gettext libz-dev libssl-dev build-essential autoconf
opam switch --root /home/opam/.opam 4.07;

eval "$(opam env --root /home/opam/.opam --set-root)"; opam install -y reason dune ocamlfind camlp4 num ocamlgraph json-wheel conf-perl yaml
eval "$(opam env --root /home/opam/.opam --set-root)" && opam install -y ./pfff
eval "$(opam env --root /home/opam/.opam --set-root)" && cd semgrep-core && opam install -y . && make all && cd ..
eval "$(opam env --root /home/opam/.opam --set-root)" && cd sgrep_lint && export PATH=/github/home/.local/bin:$PATH && sudo make all && cd ..
mkdir -p semgrep-lint-files
cp ./semgrep-core/_build/default/bin/main_sgrep.exe semgrep-lint-files/semgrep-core
cp -r ./sgrep_lint/build/sgrep.dist/* semgrep-lint-files
ls semgrep-lint-files
# TODO: remove once the Python build job makes something named `semgrep`
mv semgrep-lint-files/sgrep-lint semgrep-lint-files/semgrep
chmod +x semgrep-lint-files/semgrep-core
chmod +x semgrep-lint-files/semgrep
tar -cvzf artifacts.tar.gz semgrep-lint-files/
