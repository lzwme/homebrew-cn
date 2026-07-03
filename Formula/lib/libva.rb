class Libva < Formula
  desc "Hardware accelerated video processing library"
  homepage "https://github.com/intel/libva"
  url "https://ghfast.top/https://github.com/intel/libva/releases/download/2.24.0/libva-2.24.0.tar.bz2"
  sha256 "56fab4e482dca2c9e8280d5057294b9faa789d637f97cc394a0c6ec08159060c"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_linux:  "3e9098d5ccf92cb526ce8bead4ca4e214d61cdfb650ceca39a25c11ef2b1a261"
    sha256 cellar: :any, x86_64_linux: "6bde9f43ae18d62775a4e6c5d40670e018a3fa6a4a72f239349e094776bad164"
  end

  depends_on "pkgconf" => [:build, :test]
  depends_on "libdrm"
  depends_on "libx11"
  depends_on "libxcb"
  depends_on "libxext"
  depends_on "libxfixes"
  depends_on :linux
  depends_on "wayland"

  def install
    system "./configure", "--sysconfdir=#{etc}",
                          "--localstatedir=#{var}",
                          "--disable-silent-rules",
                          "--enable-drm",
                          "--enable-x11",
                          "--disable-glx",
                          "--enable-wayland",
                          "--with-drivers-path=#{HOMEBREW_PREFIX}/lib/dri",
                          *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    %w[libva libva-drm libva-wayland libva-x11].each do |name|
      assert_match "-I#{include}", shell_output("pkgconf --cflags #{name}")
    end

    # We cannot run a functional test without a VA-API driver; however, the
    # drivers have a dependency on `libva` which results in a dependency loop
    (testpath/"test.c").write <<~C
      #include <stddef.h>
      #include <va/va.h>
      int main(int argc, char *argv[]) {
        VADisplay display = NULL;
        vaDisplayIsValid(display);
        return 0;
      }
    C
    system ENV.cc, "test.c", "-o", "test", "-I#{include}", "-L#{lib}", "-lva"
    system "./test"
  end
end