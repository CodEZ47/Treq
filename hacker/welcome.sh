#!/bin/bash

cat <<'ART'
╔══════════════════════════════════════╗
║        TLS HANDSHAKE CHALLENGE       ║
╚══════════════════════════════════════╝

 ClientHello  ---------------->
             <----------------  ServerHello
 Certificate  <---------------
 Key Exchange ---------------->
 Finished     <-------------->

        [ Secure channel established ]
ART


echo ""
echo "Welcome to TREQ!"
echo "Your Goal is to use this container and its resources to identify 5 Flags hidden within the system."
echo ""
echo "Are you even certified to be here?"
echo ""
echo "AVAILABLE TOOLS: curl | mitmproxy"
echo ""
echo "Ready to Start?"
echo ""

