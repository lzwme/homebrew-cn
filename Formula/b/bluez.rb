class Bluez < Formula
  desc "Bluetooth protocol stack for Linux"
  homepage "https:github.combluezbluez"
  url "https:mirrors.edge.kernel.orgpublinuxbluetoothbluez-5.74.tar.xz"
  sha256 "1b35d23099f6b66d1ab065c17bf9bf286e854063e9b17477b17804d70de9089a"
  license "GPL-2.0-or-later"

  bottle do
    sha256 x86_64_linux: "9893b9f2376bf8870c7ad34c3ededbb4c3645142947b761ee6da044b2885ced9"
  end

  depends_on "pkg-config" => :build
  depends_on "dbus"
  depends_on "glib"
  depends_on "libical"
  depends_on :linux
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