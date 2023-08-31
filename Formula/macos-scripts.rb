class MacosScripts < Formula
  desc "Various command-line utility scripts for macOS"
  homepage "https://github.com/nicerloop/macos-scripts"
  url "https://ghproxy.com/https://github.com/nicerloop/macos-scripts/archive/refs/tags/v1.9.0.tar.gz"
  sha256 "505b4bd55b95bda4429c6951999d646062bfc3e6ea8789a30fecf661f59ae7cd"

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