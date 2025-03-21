class Libfuse < Formula
  desc "Reference implementation of the Linux FUSE interface"
  homepage "https:github.comlibfuselibfuse"
  url "https:github.comlibfuselibfusereleasesdownloadfuse-3.16.2fuse-3.16.2.tar.gz"
  sha256 "f797055d9296b275e981f5f62d4e32e089614fc253d1ef2985851025b8a0ce87"
  license any_of: ["LGPL-2.1-only", "GPL-2.0-only"]
  head "https:github.comlibfuselibfuse.git", branch: "master"

  bottle do
    rebuild 1
    sha256 arm64_linux:  "ea5c6e5e94c0cc55811ea6c527855761f03c080127b6f9bfa84a23f1623a7068"
    sha256 x86_64_linux: "585b1ea16d170add0e1a1a7159e266a4851fe684365491acc61319b1039a29a4"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on :linux

  def install
    args = %W[
      --sysconfdir=#{etc}
      -Dinitscriptdir=#{etc}init.d
      -Dudevrulesdir=#{etc}udevrules.d
      -Duseroot=false
    ]
    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
    (pkgshare"doc").install "dockernel.txt"
  end

  test do
    (testpath"fuse-test.c").write <<~C
      #define FUSE_USE_VERSION 31
      #include <fuse3fuse.h>
      #include <stdio.h>
      int main() {
        printf("%d%d\\n", FUSE_MAJOR_VERSION, FUSE_MINOR_VERSION);
        printf("%d\\n", fuse_version());
        return 0;
      }
    C
    system ENV.cc, "fuse-test.c", "-L#{lib}", "-I#{include}", "-D_FILE_OFFSET_BITS=64", "-lfuse3", "-o", "fuse-test"
    system ".fuse-test"
  end
end