[root@nodo01 ~]# chmod 700 /tmp/config_hugepages80.sh

[root@nodo01 ~]# cat /tmp/config_hugepages80.sh
#!/bin/bash

round() {
# Función para sacar la media de las cpus (de la función mira_cpus) ya que en algunas bash no funciona el típico:
# echo "(`lscpu |grep ^"CPU(s):" | awk -F: {'print $2'} | tr -d '[:blank:]'`)/2" | bc
echo $(printf %.$2f $(echo "scale=$2;(((10^$2)*$1)+0.5)/(10^$2)" | bc))
}

memlibre=`awk '/Hugepagesize:/{p=$2}/ 0 /{next}/ kB$/{v[sprintf("%9d GB %-s",int($2/1024/1024),$0)]=$0;next}{h[$0]=$2}END{for(k in v) print k;for (k in h) print sprintf("%9d GB %-s",p*h[k]/1024/1024,k)}' /proc/meminfo|sort -nr|grep --color=auto -E "^|.(Huge._[TF]|Mem).*:|" |grep MemFree | awk '{ print $4 }'`

pagesize=`awk '/Hugepagesize:/{p=$2}/ 0 /{next}/ kB$/{v[sprintf("%9d GB %-s",int($2/1024/1024),$0)]=$0;next}{h[$0]=$2}END{for(k in v) print k;for (k in h) print sprintf("%9d GB %-s",p*h[k]/1024/1024,k)}' /proc/meminfo|sort -nr|grep --color=auto -E "^|.(Huge._[TF]|Mem).*:|" |grep Hugepagesize | awk '{ print $4 }'`

hps=`echo $(round ${memlibre}/${pagesize} 0)`
pags=`echo $(round ${hps}*80/100 0)`

echo "${pags}" > /proc/sys/vm/nr_hugepages
echo "vm.nr_hugepages = ${pags}" >> /etc/sysctl.conf

sysctl -p >>/dev/null

awk '/Hugepagesize:/{p=$2}/ 0 /{next}/ kB$/{v[sprintf("%9d GB %-s",int($2/1024/1024),$0)]=$0;next}{h[$0]=$2}END{for(k in v) print k;for (k in h) print sprintf("%9d GB %-s",p*h[k]/1024/1024,k)}' /proc/meminfo|sort -nr|grep --color=auto -E "^|.(Huge._[TF]|Mem).*:|"
