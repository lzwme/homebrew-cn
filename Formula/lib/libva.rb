class Libva < Formula
  desc "Hardware accelerated video processing library"
  homepage "https:github.comintellibva"
  url "https:github.comintellibvareleasesdownload2.22.0libva-2.22.0.tar.bz2"
  sha256 "e3da2250654c8d52b3f59f8cb3f3d8e7fb1a2ee64378dbc400fbc5663de7edb8"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "f09fc392caac089c8689d89ccbfd9bea27689afd747313e84ff59ca21f339b78"
  end

  depends_on "pkgconf" => [:build, :test]
  depends_on "libdrm"
  depends_on "libx11"
  depends_on "libxext"
  depends_on "libxfixes"
  depends_on :linux
  depends_on "wayland"

  def install
    system ".configure", "--sysconfdir=#{etc}",
                          "--localstatedir=#{var}",
                          "--disable-silent-rules",
                          "--enable-drm",
                          "--enable-x11",
                          "--disable-glx",
                          "--enable-wayland",
                          *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    %w[libva libva-drm libva-wayland libva-x11].each do |name|
      assert_match "-I#{include}", shell_output("pkgconf --cflags #{name}")
    end
    (testpath"test.c").write <<~C
      #include <vava.h>
      int main(int argc, char *argv[]) {
        VADisplay display;
        vaDisplayIsValid(display);
        return 0;
      }
    C
    system ENV.cc, "test.c", "-o", "test", "-I#{include}", "-L#{lib}", "-lva"
    system ".test"
  end
end