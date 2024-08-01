#!/bin/bash
case "$(xset -q|grep LED| awk '{ print $10 }')" in
  "00000002") KBD="En" ;;
  "00001002") KBD="Ru" ;;
  *) KBD="unknown" ;;
esac
echo $KBD
