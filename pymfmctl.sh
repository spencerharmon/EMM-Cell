podman run --rm -i -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=$DISPLAY -h $HOSTNAME -v $HOME/.Xauthority:/root/.Xauthority -v .:/usr/app/EMM-Cell -v /mnt/cephfs/mfm_grids:/usr/app/mfm_grids/ localhost/ulam bash -s <<EOF
cd EMM-Cell
pymfmctl -c pymfmctl.yaml
EOF
