class Libfuse < Formula
  desc "Reference implementation of the Linux FUSE interface"
  homepage "https://github.com/libfuse/libfuse"
  url "https://ghproxy.com/https://github.com/libfuse/libfuse/releases/download/fuse-3.15.1/fuse-3.15.1.tar.gz"
  sha256 "13ef77cda531a21c2131f9576042970e98035c0a5f019abf661506efd2d38a4e"
  license any_of: ["LGPL-2.1-only", "GPL-2.0-only"]
  head "https://github.com/libfuse/libfuse.git", branch: "master"

  bottle do
    rebuild 1
    sha256 x86_64_linux: "bbdf695b0085f7cd4715d5cdabf659f362546aa76ac7db4ef29740278ce95bff"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on :linux

  def install
    args = std_meson_args + %W[
      --sysconfdir=#{etc}
      -Dinitscriptdir=#{etc}/init.d
      -Dudevrulesdir=#{etc}/udev/rules.d
      -Duseroot=false
    ]
    mkdir "build" do
      system "meson", *args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
    (pkgshare/"doc").install "doc/kernel.txt"
  end

  test do
    (testpath/"fuse-test.c").write <<~EOS
      #define FUSE_USE_VERSION 31
      #include <fuse3/fuse.h>
      #include <stdio.h>
      int main() {
        printf("%d%d\\n", FUSE_MAJOR_VERSION, FUSE_MINOR_VERSION);
        printf("%d\\n", fuse_version());
        return 0;
      }
    EOS
    system ENV.cc, "fuse-test.c", "-L#{lib}", "-I#{include}", "-D_FILE_OFFSET_BITS=64", "-lfuse3", "-o", "fuse-test"
    system "./fuse-test"
  end
end