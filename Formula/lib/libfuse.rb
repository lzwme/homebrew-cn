class Libfuse < Formula
  desc "Reference implementation of the Linux FUSE interface"
  homepage "https://github.com/libfuse/libfuse"
  url "https://ghfast.top/https://github.com/libfuse/libfuse/releases/download/fuse-3.17.3/fuse-3.17.3.tar.gz"
  sha256 "de8190448909aa97a222d435bc130aae98331bed4215e9f4519b4b5b285a1d63"
  license any_of: ["LGPL-2.1-only", "GPL-2.0-only"]
  head "https://github.com/libfuse/libfuse.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_linux:  "d3420beb1fc5beb1204222f12c1e3075d988ea07c6176823f317b06477825778"
    sha256 x86_64_linux: "d75d8c9083b235293177dd4607399654a61dbc8bc9d6bae765141ad6f21daa0d"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on :linux

  def install
    args = %W[
      --sysconfdir=#{etc}
      -Dinitscriptdir=#{etc}/init.d
      -Dudevrulesdir=#{etc}/udev/rules.d
      -Duseroot=false
    ]
    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
    (pkgshare/"doc").install "doc/kernel.txt"
  end

  test do
    (testpath/"fuse-test.c").write <<~C
      #define FUSE_USE_VERSION 31
      #include <fuse3/fuse.h>
      #include <stdio.h>
      int main() {
        printf("%d%d\\n", FUSE_MAJOR_VERSION, FUSE_MINOR_VERSION);
        printf("%d\\n", fuse_version());
        return 0;
      }
    C
    system ENV.cc, "fuse-test.c", "-L#{lib}", "-I#{include}", "-D_FILE_OFFSET_BITS=64", "-lfuse3", "-o", "fuse-test"
    system "./fuse-test"
  end
end