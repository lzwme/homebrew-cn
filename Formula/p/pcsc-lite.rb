class PcscLite < Formula
  desc "Middleware to access a smart card using SCard API"
  homepage "https:pcsclite.apdu.fr"
  url "https:pcsclite.apdu.frfilespcsc-lite-2.2.0.tar.xz"
  sha256 "76e06bb9f47f0c10c4eaec3ee9cea634bda28a1fc46f1286c097d220386c22d4"
  license all_of: ["BSD-3-Clause", "GPL-3.0-or-later", "ISC"]

  livecheck do
    url "https:pcsclite.apdu.frfiles"
    regex(href=.*?pcsc-lite[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "1d3d605c39ff83bc38fb849e6c95a1fdb141d199c27593245f5ed6cbe4a0b68c"
    sha256 cellar: :any, arm64_ventura:  "99bb28dd8e565a3ecfb31c538c229dfe119b0da90fc318588fa682e6af24cac4"
    sha256 cellar: :any, arm64_monterey: "ad594f9c1c15fa13f9c471ad9cbe09ef0912d60910a459e17b05c7b6e30fac4b"
    sha256 cellar: :any, sonoma:         "893c0fba4fe32c83fc8ae1af819330d6e3282bd367e5bba0391db5a0ea0cb8b4"
    sha256 cellar: :any, ventura:        "8287bd0dfbb88d7e40fe4908587163dd5ff39c3562d5b2492a94a283b1d5aa64"
    sha256 cellar: :any, monterey:       "2a50dcd08d8a2f9898be48ed1810536f7e8f34750271d419c7343ce1ad3c1586"
    sha256               x86_64_linux:   "b646ef4ea50dc026e3e4ae480c76e446f4d0783952b770a49c7d92536a07d1c6"
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

  # upstream build patch for https:github.comLudovicRousseauPCSCissues179
  patch do
    url "https:salsa.debian.orgrousseauPCSC-commit960e367edc01518b90684ffff99010ee07ae1bd4.patch"
    sha256 "30e5e3c5ca16d18243c6cf7db662f4cc504e05ccc0c70747f34832397ae1cdd5"
  end

  def install
    args = %W[
      -Dlibsystemd=false
      -Dlibudev=false
      -Dpolkit=false
      -Dipcdir=#{var}run
      -Dsysconfdir=#{etc}
      -Dsbindir=#{sbin}
    ]

    args << "-Dlibudev=false" if OS.linux?

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    system sbin"pcscd", "--version"
  end
end