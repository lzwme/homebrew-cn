cask "intel-haxm" do
  version "7.8.0"
  sha256 "44059b3ad33de87562ecd7a6c5a003dce96aa51506667752601467af7b328c29"

  url "https://ghfast.top/https://github.com/intel/haxm/releases/download/v#{version}/haxm-macosx_v#{version.dots_to_underscores}.zip"
  name "Intel HAXM"
  desc "Hardware-assisted virtualization engine (hypervisor)"
  homepage "https://github.com/intel/haxm"

  no_autobump! because: :requires_manual_review

  disable! date: "2024-12-16", because: :discontinued

  depends_on macos: ">= :sierra"
  depends_on arch: :x86_64

  installer script: {
    executable: "silent_install.sh",
    sudo:       true,
  }

  uninstall script:  {
              sudo:         true,
              must_succeed: true,
              executable:   "silent_install.sh",
              args:         ["-u"],
            },
            pkgutil: "com.intel.kext.haxm.*"

  caveats do
    kext
  end
end