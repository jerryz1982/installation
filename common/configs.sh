#!/usr/bin/env bash


function update_lvm_filter() {
    if [ ! -f /etc/lvm/lvm.conf.bak ]; then
        cp /etc/lvm/lvm.conf /etc/lvm/lvm.conf.bak
    fi
    _filter="'r/.*/'"
    LVMS=$(pvdisplay | grep 'PV Name' | awk '{print $3}' | sed -r "s#/dev/##g")
    for lvm in $LVMS; do
        _filter="'a/$lvm/', $_filter"
    done
    _filter="[ $_filter ]"
    cat > /etc/lvm/lvm.conf << EOF
config {
	checks = 1
	abort_on_errors = 0
	profile_dir = "/etc/lvm/profile"
}
devices {
	dir = "/dev"
	scan = [ "/dev" ]
	obtain_device_list_from_udev = 1
	external_device_info_source = "none"
	preferred_names = [ "^/dev/mpath/", "^/dev/mapper/mpath", "^/dev/[hs]d" ]
	filter = $(echo $_filter)
	cache_dir = "/etc/lvm/cache"
	cache_file_prefix = ""
	write_cache_state = 1
	sysfs_scan = 1
	multipath_component_detection = 1
	md_component_detection = 1
	fw_raid_component_detection = 0
	md_chunk_alignment = 1
	data_alignment_detection = 1
	data_alignment = 0
	data_alignment_offset_detection = 1
	ignore_suspended_devices = 0
	ignore_lvm_mirrors = 1
	disable_after_error_count = 0
	require_restorefile_with_uuid = 1
	pv_min_size = 2048
	issue_discards = 0
	allow_changes_with_duplicate_pvs = 1
}
allocation {
	maximise_cling = 1
	use_blkid_wiping = 1
	wipe_signatures_when_zeroing_new_lvs = 1
	mirror_logs_require_separate_pvs = 0
	cache_pool_metadata_require_separate_pvs = 0
	thin_pool_metadata_require_separate_pvs = 0
}
log {
	verbose = 0
	silent = 0
	syslog = 1
	overwrite = 0
	level = 0
	indent = 1
	command_names = 0
	prefix = "  "
	activation = 0
	debug_classes = [ "memory", "devices", "activation", "allocation", "lvmetad", "metadata", "cache", "locking", "lvmpolld", "dbus" ]
}
backup {
	backup = 1
	backup_dir = "/etc/lvm/backup"
	archive = 1
	archive_dir = "/etc/lvm/archive"
	retain_min = 10
	retain_days = 30
}
shell {
	history_size = 100
}
global {
	umask = 077
	test = 0
	units = "r"
	si_unit_consistency = 1
	suffix = 1
	activation = 1
	proc = "/proc"
	etc = "/etc"
	locking_type = 1
	wait_for_locks = 1
	fallback_to_clustered_locking = 1
	fallback_to_local_locking = 1
	locking_dir = "/run/lock/lvm"
	prioritise_write_locks = 1
	abort_on_internal_errors = 0
	detect_internal_vg_cache_corruption = 0
	metadata_read_only = 0
	mirror_segtype_default = "raid1"
	raid10_segtype_default = "raid10"
	sparse_segtype_default = "thin"
	use_lvmetad = 1
	use_lvmlockd = 0
	system_id_source = "none"
	use_lvmpolld = 1
	notify_dbus = 1
}
activation {
	checks = 0
	udev_sync = 1
	udev_rules = 1
	verify_udev_operations = 0
	retry_deactivation = 1
	missing_stripe_filler = "error"
	use_linear_target = 1
	reserved_stack = 64
	reserved_memory = 8192
	process_priority = -18
	raid_region_size = 2048
	readahead = "auto"
	raid_fault_policy = "warn"
	mirror_image_fault_policy = "remove"
	mirror_log_fault_policy = "allocate"
	snapshot_autoextend_threshold = 100
	snapshot_autoextend_percent = 20
	thin_pool_autoextend_threshold = 100
	thin_pool_autoextend_percent = 20
	use_mlockall = 0
	monitoring = 1
	polling_interval = 15
	activation_mode = "degraded"
}
dmeventd {
	mirror_library = "libdevmapper-event-lvm2mirror.so"
	snapshot_library = "libdevmapper-event-lvm2snapshot.so"
	thin_library = "libdevmapper-event-lvm2thin.so"
}
EOF
}

function _create_initial_flavors() {
    m1.tiny_ram=512; m1.tiny_disk=1; m1.tiny_vcpu=1
    m1.small_ram=2048; m1.small_disk=20; m1.small_vcpu=1
    m1.medium_ram=4096; m1.medium_disk=40; m1.medium_vcpu=2
    m1.large_ram=8192; m1.large_disk=80; m1.large_vcpu=4
    m1.xlarge_ram=16384; m1.xlarge_disk=160; m1.xlarge_vcpu=8
    flavors=(m1.tiny m1.small m1.medium m1.large m1.xlarge)
    for flavor in ${flavors[@]}; do
        openstack flavor show $flavor
        if [ $? -eq 1 ]; then
            openstack flavor create --public $flavor --ram ${flavor}_ram --disk ${flavor}_disk --vcpus ${flavor}_vcpu
        fi
    done
}
