class Bluez < Formula
  desc "Bluetooth protocol stack for Linux"
  homepage "https://www.bluez.org"
  url "https://mirrors.edge.kernel.org/pub/linux/bluetooth/bluez-5.81.tar.xz"
  sha256 "c600c61f149a3a699405f187bf4891f525e277ad24b6b53bf073d9848a070652"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://mirrors.edge.kernel.org/pub/linux/bluetooth/"
    regex(/href=.*?bluez[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_linux:  "f53988293f8364c8c4e010110b276e1aaa3c5294c4d1c77c1e278b9d920c6fce"
    sha256 x86_64_linux: "aa7fb97887350dc466d7c5ce4b017d1da933696c532a405a7fbded228226b459"
  end

  head do
    url "https://git.kernel.org/pub/scm/bluetooth/bluez.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkgconf" => :build
  depends_on "dbus"
  depends_on "glib"
  depends_on "libical"
  depends_on :linux
  depends_on "readline"
  depends_on "systemd" # for libudev

  def install
    system "autoreconf", "--force", "--install", "--verbose" if build.head?
    system "./configure", "--disable-testing", "--disable-manpages", "--enable-library", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bluetoothctl --version") unless head?

    assert_match "Failed to open HCI user channel", shell_output("#{bin}/bluemoon 2>&1", 1)

    output = shell_output("#{bin}/btmon 2>&1", 1)
    assert_match "Failed to open channel: Address family not supported by protocol", output
  end
end