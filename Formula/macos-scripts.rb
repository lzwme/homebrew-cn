class MacosScripts < Formula
  desc "Various command-line utility scripts for macOS"
  homepage "https://github.com/nicerloop/macos-scripts"
  url "https://ghproxy.com/https://github.com/nicerloop/macos-scripts/archive/refs/tags/v1.9.1.tar.gz"
  sha256 "a0837b36fd8edd8ef613503ea0de81061207952f9f6af8923e2746b99d993de1"

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