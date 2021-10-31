#!/bin/bash

geth --datadir $HOME/HW3/test-eth1 --networkid=2310 --syncmode full --gcmode archive --nodiscover init $HOME/HW3/genesis.json
gnome-terminal -- ./startIpc.sh
geth  --datadir $HOME/HW3/test-eth1 --networkid 2310 --nodiscover

