class PcscLite < Formula
  desc "Middleware to access a smart card using SCard API"
  homepage "https://pcsclite.apdu.fr/"
  url "https://pcsclite.apdu.fr/files/pcsc-lite-2.2.2.tar.xz"
  sha256 "04edaed13565aab0fa7c711382be2b02e38faffbccd024ab68085ffb7091be22"
  license all_of: ["BSD-3-Clause", "GPL-3.0-or-later", "ISC"]

  livecheck do
    url "https://pcsclite.apdu.fr/files/"
    regex(/href=.*?pcsc-lite[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "01c98f4c5da3bf4c902ff384cb26064b2b7b42e4c113b9ca4f1161dcb057a850"
    sha256 cellar: :any, arm64_ventura:  "8d5eaede49d4a3021ee949712a5ac41af2798b5cc4b65a4368e22579885862e4"
    sha256 cellar: :any, arm64_monterey: "b10524e16d413827dbd7f5733b6b3866785f79682723a403b4097a668da1cfc5"
    sha256 cellar: :any, sonoma:         "3ba320bdf0e350c845ae40eceb1ea872e2c46f6f1a05ac5843d78d850b7a5bf4"
    sha256 cellar: :any, ventura:        "3e49a3159bdaee9c50a070ac5cf093db7e052a64ee24fc0c13b5e407548baca3"
    sha256 cellar: :any, monterey:       "8e4a5848164c2397791f12a5089d8d3ad0bda132444950b082f3df66039837e7"
    sha256               x86_64_linux:   "af8039010fd29720089df46013ffeea2b39fac580bec350dcd7d9af9801cb544"
  end

  keg_only :shadowed_by_macos, "macOS provides PCSC.framework"

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build

  uses_from_macos "flex" => :build

  on_linux do
    depends_on "libusb"
    depends_on "systemd" # for libudev
  end

  def install
    args = %W[
      -Dlibsystemd=false
      -Dlibudev=false
      -Dpolkit=false
      -Dipcdir=#{var}/run
      -Dsysconfdir=#{etc}
      -Dsbindir=#{sbin}
    ]

    args << "-Dlibudev=false" if OS.linux?

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    system sbin/"pcscd", "--version"
  end
end