class Ddcutil < Formula
  desc "Control monitor settings using DDC/CI and USB"
  homepage "https://www.ddcutil.com"
  url "https://www.ddcutil.com/tarballs/ddcutil-2.2.2.tar.gz"
  sha256 "2930a14f0f348c046b821b5b240724b02e47d0494e4eb90808191ec555be2b73"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.ddcutil.com/releases/"
    regex(/href=.*?ddcutil[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "6cfbc782c103d7071b27f30ddbb6c99105b3993ccfadbe4e4f4ab694a57056ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "2a3d17256f99e2aab50b7c1b3ad24991a2431559ce2f04ff42757eac9c42869a"
  end

  depends_on "pkgconf" => :build
  depends_on "glib"
  depends_on "i2c-tools"
  depends_on "jansson"
  depends_on "kmod"
  depends_on "libdrm"
  depends_on "libusb"
  depends_on "libx11"
  depends_on "libxext"
  depends_on "libxrandr"
  depends_on :linux
  depends_on "systemd"

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    assert_match "The following tests probe the runtime environment using multiple overlapping methods.",
      shell_output("#{bin}/ddcutil environment")
  end
end