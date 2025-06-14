#!/bin/bash
set -e

#--- CONFIGURE HUGE PAGES ---
HUGEPAGES=3072
HUGEPAGE_SIZE_KB=2048 # 2MB pages, default on most systems

echo "Setting up $HUGEPAGES hugepages of $HUGEPAGE_SIZE_KB kB each..."

# 1. Configure hugepages at runtime
sudo sysctl -w vm.nr_hugepages=$HUGEPAGES

# 2. Make hugepages setting persistent
echo "vm.nr_hugepages = $HUGEPAGES" | sudo tee /etc/sysctl.d/60-hugepages.conf

# 3. Reload sysctl to apply persistent changes
sudo sysctl --system

# 4. Optional: Mount hugetlbfs for applications that use it
HUGE_MOUNTPOINT="/mnt/huge"
sudo mkdir -p $HUGE_MOUNTPOINT
if ! grep -q hugetlbfs /proc/mounts; then
    sudo mount -t hugetlbfs none $HUGE_MOUNTPOINT
    # Ensure it mounts at boot
    if ! grep -q "$HUGE_MOUNTPOINT" /etc/fstab; then
        echo "none $HUGE_MOUNTPOINT hugetlbfs defaults 0 0" | sudo tee -a /etc/fstab
    fi
fi

# 5. Show result
echo "Hugepages status:"
grep -i huge /proc/meminfo

echo "Provisioning of $HUGEPAGES hugepages complete."
