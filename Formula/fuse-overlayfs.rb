class FuseOverlayfs < Formula
  desc "FUSE implementation for overlayfs"
  homepage "https://github.com/containers/fuse-overlayfs"
  url "https://ghproxy.com/https://github.com/containers/fuse-overlayfs/archive/refs/tags/v1.10.tar.gz"
  sha256 "4351eaed7cf26a5012c14c6e0fc883ef65a7b5dcc95ba129ce485904106c25a9"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "abbc5127c91f4ddd02a48858f43581f2aab41ff4fb2318f90c0d8f9882c9e964"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build

  depends_on "libfuse"
  depends_on :linux

  def install
    system "autoreconf", "-fis"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    mkdir "lowerdir/a"
    mkdir "lowerdir/b"
    mkdir "up"
    mkdir "workdir"
    mkdir "merged"
    test_cmd = "fuse-overlayfs -o lowerdir=lowerdir/a:lowerdir/b,upperdir=up,workdir=workdir merged 2>&1"
    output = shell_output(test_cmd, 1)
    assert_match "fuse: device not found, try 'modprobe fuse' first", output
    assert_match "fuse-overlayfs: cannot mount: No such file or directory", output
  end
end