#
# TARGET_WLAN_CHIP directs QCACLD driver to be built for that particular
# chipset(s). It can take multiple supported chipsets. Please refer QCACLD
# driver code for supported chipsets.
#
# Default behaviour is invoked if TARGET_WLAN_CHIP is not defined.
#
# It also installs chip specific INI files.
#
# e.g. TARGET_WLAN_CHIP := qca6490 qca6390
#	builds qca_cld3_qca6490.ko and qca_cld3_qca6390.ko
#
#	Copies configuration files from device/qcom/wlan/parrot/ to
#	$(TARGET_COPY_OUT_VENDOR)/etc/wifi/ like,
#
#	WCNSS_qcom_cfg_qca6490.ini -> qca6490/WCNSS_qcom_cfg.ing
#	WCNSS_qcom_cfg_qca6390.ini -> qca6390/WCNSS_qcom_cfg.ing
#
#
TARGET_WLAN_CHIP := qca6750 adrastea qca6490

WLAN_CHIPSET := qca_cld3

# Force chip-specific DLKM name
TARGET_MULTI_WLAN := true

#WPA
WPA := wpa_cli

# Package chip specific ko files if TARGET_WLAN_CHIP is defined.
ifneq ($(TARGET_WLAN_CHIP),)
	PRODUCT_PACKAGES += $(foreach chip, $(TARGET_WLAN_CHIP), $(WLAN_CHIPSET)_$(chip).ko)
else
	PRODUCT_PACKAGES += $(WLAN_CHIPSET)_wlan.ko
endif
PRODUCT_PACKAGES += wifilearner
PRODUCT_PACKAGES += $(WPA)
PRODUCT_PACKAGES += lowirpcd
PRODUCT_PACKAGES += qsh_wifi_test
PRODUCT_PACKAGES += init.vendor.wlan.rc
PRODUCT_PACKAGES += wificfrtool
PRODUCT_PACKAGES += ctrlapp_dut

#Enable WIFI AWARE FEATURE
WIFI_HIDL_FEATURE_AWARE := true

# Copy chip specific INI files if TARGET_WLAN_CHIP is defined
ifneq ($(TARGET_WLAN_CHIP),)
	PRODUCT_COPY_FILES += \
			      $(foreach chip, $(TARGET_WLAN_CHIP), \
			      device/qcom/wlan/parrot/WCNSS_qcom_cfg_$(chip).ini:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/$(chip)/WCNSS_qcom_cfg.ini)
else
	PRODUCT_COPY_FILES += \
			      device/qcom/wlan/parrot/WCNSS_qcom_cfg.ini:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/WCNSS_qcom_cfg.ini

endif

PRODUCT_COPY_FILES += \
				device/qcom/wlan/parrot/wpa_supplicant_overlay.conf:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/wpa_supplicant_overlay.conf \
				device/qcom/wlan/parrot/p2p_supplicant_overlay.conf:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/p2p_supplicant_overlay.conf \
				device/qcom/wlan/parrot/icm.conf:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/icm.conf \
				device/qcom/wlan/parrot/vendor_cmd.xml:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/vendor_cmd.xml \
                                frameworks/native/data/etc/android.hardware.wifi.aware.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.aware.xml \
                                frameworks/native/data/etc/android.hardware.wifi.rtt.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.rtt.xml \
                                frameworks/native/data/etc/android.hardware.wifi.passpoint.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.passpoint.xml

# Enable STA + SAP Concurrency.
WIFI_HIDL_FEATURE_DUAL_INTERFACE := true

# Enable SAP + SAP Feature.
QC_WIFI_HIDL_FEATURE_DUAL_AP := true

# Enable vendor properties.
PRODUCT_PROPERTY_OVERRIDES += \
	wifi.aware.interface=wifi-aware0

# Enable STA + STA Feature.
QC_WIFI_HIDL_FEATURE_DUAL_STA := true

#Disable cnss-daemon QMI communication with FW
TARGET_USES_NO_FW_QMI_CLIENT := true

#Disable DMS MAC address feature in cnss-daemon
TARGET_USES_NO_DMS_QMI_CLIENT := true

#Disable subnet detection
TARGET_USES_NO_SUBNET_DETECTION := true
