class Libfuse < Formula
  desc "Reference implementation of the Linux FUSE interface"
  homepage "https:github.comlibfuselibfuse"
  url "https:github.comlibfuselibfusereleasesdownloadfuse-3.17.2fuse-3.17.2.tar.gz"
  sha256 "3d932431ad94e86179e5265cddde1d67aa3bb2fb09a5bd35c641f86f2b5ed06f"
  license any_of: ["LGPL-2.1-only", "GPL-2.0-only"]
  head "https:github.comlibfuselibfuse.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_linux:  "447962f98f38e97d6235096dbc5cd7453345c893ea5cf3f9099fe8115dec707e"
    sha256 x86_64_linux: "11f5d2472fd50b34f28e07e94ddf10b8bfca48e6b8725724e8260ebc0b0fbb1d"
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