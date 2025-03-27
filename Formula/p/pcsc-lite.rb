class PcscLite < Formula
  desc "Middleware to access a smart card using SCard API"
  homepage "https://pcsclite.apdu.fr/"
  url "https://pcsclite.apdu.fr/files/pcsc-lite-2.3.2.tar.xz"
  sha256 "5ac5091d444653c5f63add9c6c39a777c11c5f3513491639c0f3385ccb41496d"
  license all_of: ["BSD-3-Clause", "GPL-3.0-or-later", "ISC"]

  livecheck do
    url "https://pcsclite.apdu.fr/files/"
    regex(/href=.*?pcsc-lite[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia: "51d0f97ecab97967b789967570db3cec93aad6c67980d370c13e750b6506b399"
    sha256 cellar: :any, arm64_sonoma:  "0089d35c7514659d52bfb212f5125763eaa7792c9748db3f7e528f7034ce5ad8"
    sha256 cellar: :any, arm64_ventura: "867aaa332c69cb979de650befd3879fca8f79372a684146d332d22fe0c404c99"
    sha256 cellar: :any, sonoma:        "3e31ff91425c717c8aba88c516bca1614ef610a756d10600ce4c7765299c97ce"
    sha256 cellar: :any, ventura:       "c80bdeba1b329abd108da2f299238270af8692029ea6d4e25b11ae90c84c70a0"
    sha256               arm64_linux:   "37f15b1de4c0d72bdfee907d1f739163558862f4434d692abf5f9637a175b8a1"
    sha256               x86_64_linux:  "9802b4ad92485a822689529b606b8bd05176884f341e87a33ff4bc868533a7d0"
  end

  keg_only :shadowed_by_macos, "macOS provides PCSC.framework"

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

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