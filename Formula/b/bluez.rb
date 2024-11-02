class Bluez < Formula
  desc "Bluetooth protocol stack for Linux"
  homepage "https:github.combluezbluez"
  url "https:mirrors.edge.kernel.orgpublinuxbluetoothbluez-5.79.tar.xz"
  sha256 "4164a5303a9f71c70f48c03ff60be34231b568d93a9ad5e79928d34e6aa0ea8a"
  license "GPL-2.0-or-later"

  bottle do
    sha256 x86_64_linux: "8c67b7d3aac221d00420c11e5de419b8d3277a2be8b15a5fdf38691b13328dd6"
  end

  depends_on "pkg-config" => :build
  depends_on "dbus"
  depends_on "glib"
  depends_on "libical"
  depends_on :linux
  depends_on "readline"
  depends_on "systemd" # for libudev

  def install
    system ".configure", "--disable-testing", "--disable-manpages", "--enable-library", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}bluetoothctl --version")

    assert_match "Failed to open HCI user channel", shell_output("#{bin}bluemoon 2>&1", 1)

    output = shell_output("#{bin}btmon 2>&1", 1)
    assert_match "Failed to open channel: Address family not supported by protocol", output
  end
end