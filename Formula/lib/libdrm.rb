class Libdrm < Formula
  desc "Library for accessing the direct rendering manager"
  homepage "https://dri.freedesktop.org"
  url "https://dri.freedesktop.org/libdrm/libdrm-2.4.116.tar.xz"
  sha256 "46c53f40735ea3d26d614297f155f6131a510624a24274f654f6469ca905339a"
  license "MIT"

  livecheck do
    url "https://dri.freedesktop.org/libdrm/"
    regex(/href=.*?libdrm[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 x86_64_linux: "f0f99c7cedf8010d9d704c1c64708be4ea111cb8523e6c9fd14de0c4ad9aacbd"
  end

  depends_on "docutils" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "libpciaccess"
  depends_on :linux

  def install
    system "meson", "setup", "build", "-Dcairo-tests=disabled", "-Dvalgrind=disabled", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <libdrm/drm.h>
      int main(int argc, char* argv[]) {
        struct drm_gem_open open;
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-ldrm"
  end
end