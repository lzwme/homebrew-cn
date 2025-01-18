class Ifuse < Formula
  desc "FUSE module for iOS devices"
  homepage "https:libimobiledevice.org"
  url "https:github.comlibimobiledeviceifusearchiverefstags1.1.4.tar.gz"
  sha256 "2a00769e8f1d8bad50898b9d00baf12c8ae1cda2d19ff49eaa9bf580e5dbe78c"
  license "LGPL-2.1-or-later"
  revision 1
  head "https:github.comlibimobiledeviceifuse.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, x86_64_linux: "4f5277e44f39b185e4fbed2f1634e4e6e57b48651dd117cb9b6c5dfcc6acab0a"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "glib"
  depends_on "libfuse@2"
  depends_on "libimobiledevice"
  depends_on "libplist"
  depends_on :linux # on macOS, requires closed-source macFUSE

  def install
    system ".autogen.sh", *std_configure_args
    system "make", "install"
  end

  test do
    # Actual test of functionality requires osxfuse, so test for expected failure instead
    assert_match "ERROR: No device found!", shell_output("#{bin}ifuse --list-apps", 1)
  end
end