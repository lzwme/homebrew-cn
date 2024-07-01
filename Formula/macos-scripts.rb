class MacosScripts < Formula
  desc "Various command-line utility scripts for macOS"
  homepage "https:github.comnicerloopmacos-scripts"
  url "https:github.comnicerloopmacos-scriptsarchiverefstagsv1.9.2.tar.gz"
  sha256 "2586d6617111960b0ec7b1258acd5f5abd3f95745b78c567c08c54dc33cae44e"

  def install
    bin.install "brew-bundle-leaves"
    bin.install "brew-bundle-patch-install-receipts"
    bin.install "launchpad-reset"
    bin.install "launchpad-sort"
    bin.install "login-picture"
    bin.install "mas-versions.sh" => "mas-versions"
    bin.install "rsync-backup"
    bin.install "smb-volume-mount"
    bin.install "sudo-pam-configure"
    bin.install "vnc-connect"
    bin.install "volume-icon"
    bin.install "webloc-to-url"
    bin.install "xcode-command-line-tools-reinstall"
    bin.install "xcode-uninstall"
  end
end