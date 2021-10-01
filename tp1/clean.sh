# enlever les switches
BRIDGES=$(cat build_architecture | awk '/^ovs-vsctl add-br/ { print $3 }')
NAMESPACES=$(cat build_architecture | awk '/^ip netns add/ { print $4 }')
LINKS=$(cat build_architecture | awk '/peer name/ { print $9 }')
DIRECTORIES=$(cat build_architecture | awk '/mkdir / { print $3 }')
for BRIDGE in $BRIDGES
do
	sudo ovs-vsctl del-br $BRIDGE
done
for NAMESPACE in $NAMESPACES
do
	sudo ip netns del $NAMESPACE
done
for LINK in $LINKS
do
	sudo ip l del $LINK
done
for DIRECTORY in $DIRECTORIES
do
	sudo rm $DIRECTORY/*
done
