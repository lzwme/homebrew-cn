class Ifuse < Formula
  desc "FUSE module for iOS devices"
  homepage "https:libimobiledevice.org"
  license "LGPL-2.1-or-later"
  revision 1
  head "https:github.comlibimobiledeviceifuse.git", branch: "master"

  stable do
    url "https:github.comlibimobiledeviceifusearchiverefstags1.1.4.tar.gz"
    sha256 "2a00769e8f1d8bad50898b9d00baf12c8ae1cda2d19ff49eaa9bf580e5dbe78c"

    # Backport support for libfuse 3
    patch do
      url "https:github.comlibimobiledeviceifusecommit36956a5179e224f57ebb9d0f01314c09c8bf0f97.patch?full_index=1"
      sha256 "47c87159f085977bc728f586c975b343f67bdf221b164bfef10a572546e80df3"
    end
  end

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, x86_64_linux: "b3182da5c1d4d56eb06f4edcdc6d375b21f808437f3adfbf044e69d881dc3b7f"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "glib"
  depends_on "libfuse"
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