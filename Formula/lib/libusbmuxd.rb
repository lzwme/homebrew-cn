class Libusbmuxd < Formula
  desc "USB multiplexor library for iOS devices"
  homepage "https://www.libimobiledevice.org/"
  url "https://ghproxy.com/https://github.com/libimobiledevice/libusbmuxd/archive/2.0.2.tar.gz"
  sha256 "8ae3e1d9340177f8f3a785be276435869363de79f491d05d8a84a59efc8a8fdc"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]
  revision 1
  head "https://github.com/libimobiledevice/libusbmuxd.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a35936b03dba9cecdd2af294daa9b7a879ad9c11043f557f2531e799a3fd71aa"
    sha256 cellar: :any,                 arm64_monterey: "92201ac3007f70957e11d1cc9be9ae9862202559a95f95456f8b7bf76fd9b204"
    sha256 cellar: :any,                 arm64_big_sur:  "9f995ac0325e79244ca44de94d0c5f86292e2f565d2205bb6bb43fe61856c16f"
    sha256 cellar: :any,                 ventura:        "2cc0d1c983ab8d088af3dc0b8f4fd9d555a7e95908066d2ee33df58ae7a0961c"
    sha256 cellar: :any,                 monterey:       "4f5a4f31c18fc736e2c5d32564df1337995f936564cbb935675d45d3fd3eb249"
    sha256 cellar: :any,                 big_sur:        "5dcfdb9eb43ac45ced1eefb9b88b25a48e99198ee8c57e466bcb5112392d1de1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7ad184b5e9e783b812d7650059b43918680f15f400accc7813fba239a9c25e81"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libplist"
  depends_on "libusb"

  uses_from_macos "netcat" => :test

  def install
    system "./autogen.sh", *std_configure_args, "--disable-silent-rules"
    system "make", "install"
  end

  test do
    source = free_port
    dest = free_port
    fork do
      exec bin/"iproxy", "-s", "localhost", "#{source}:#{dest}"
    end

    sleep(2)
    system "nc", "-z", "localhost", source
  end
end