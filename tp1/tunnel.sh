#!/bin/bash

K1="0xa746a45291bae5ad7ae34b1edc4a0357073873ef15a701e478af0d573f3ffb8a"
K2="0x1a1dabd1a71a9e57baae036c15cc23ace86cf206c782bb062ac5a78ab2c4fc96"
K3="0xcb77e13a562939b03a73c12531518c0e164090134579654e8abe3cec3c9cc8c7"
K4="0x94b9707c752e07b6407718f9b3a2825de5dd2f1b14f2423777cf7c226afe0cae"

RID1="0x110a7155"
RID2="0x0a25c256"

SPI1="0x4f0ac8b7"
SPI2="0x515d8ec0"

ip netns e h1 ip xfrm state flush
ip netns e h1 xfrm policy flush

ip netns e h1 ip xfrm state add src 10.10.10.1 dst 10.0.0.1 proto esp spi "$SPI1" reqid "$RID1" mode tunnel auth sha256 "$K1" enc aes "$K2"
ip netns e h1 ip xfrm state add src 10.0.0.1 dst 10.10.10.1 proto esp spi "$SPI2" reqid "$RID2" mode tunnel auth sha256 "$K3" enc aes "$K4"

ip netns e h1 ip xfrm policy add src 10.10.10.1 dst 10.0.0.1 dir out tmpl src 10.10.10.1 dst 10.0.0.1 proto esp reqid "$RID1" mode tunnel
ip netns e h1 ip xfrm policy add src 10.0.0.1 dst 10.10.10.1 dir in tmpl src 10.0.0.1 dst 10.10.10.1 proto esp reqid "$RID2" mode tunnel

ip netns e h2 ip xfrm state flush
ip netns e h2 xfrm policy flush

ip netns e h2 ip xfrm state add src 10.10.10.1 dst 10.0.0.1 proto esp spi "$SPI1" reqid "$RID1" mode tunnel auth sha256 "$K1" enc aes "$K2"
ip netns e h2 ip xfrm state add src 10.0.0.1 dst 10.10.10.1 proto esp spi "$SPI2" reqid "$RID2" mode tunnel auth sha256 "$K3" enc aes "$K4"

ip netns e h2 ip xfrm policy add src 10.10.10.1 dst 10.0.0.1 dir in tmpl src 10.10.10.1 dst 10.0.0.1 proto esp reqid "$RID1" mode tunnel
ip netns e h2 ip xfrm policy add src 10.0.0.1 dst 10.10.10.1 dir out tmpl src 10.0.0.1 dst 10.10.10.1 proto esp reqid "$RID2" mode tunnel