class Suil < Formula
  desc "Lightweight C library for loading and wrapping LV2 plugin UIs"
  homepage "https://drobilla.net/software/suil.html"
  url "https://download.drobilla.net/suil-0.10.22.tar.xz"
  sha256 "d720969e0f44a99d5fba35c733a43ed63a16b0dab867970777efca4b25387eb7"
  license "ISC"
  head "https://gitlab.com/lv2/suil.git", branch: "main"

  livecheck do
    url "https://download.drobilla.net/"
    regex(/href=.*?suil[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 2
    sha256 arm64_tahoe:   "beeb7b73619489f0cee7601a170abc1290c16ee9ba097f57fcbd628fbd7d300d"
    sha256 arm64_sequoia: "25a6bf27bf30c162f447f501020cd9eeb80c3cdea9c67f2cf342bf2717aa57c9"
    sha256 arm64_sonoma:  "ead556e804f93c966a0100d8e8e94385848c98b757c2c1cd53a5f19514512caa"
    sha256 sonoma:        "1c238cde79a053b3ff7799932eddb53d6128b098c21c98237c96fac207de9b1f"
    sha256 arm64_linux:   "65176e9df395adf5d1ee73374dd68486a87753b0186a16a440a61e7870780eb5"
    sha256 x86_64_linux:  "80a3d62881ba344a399c18f69ba815c74dc54efdfa0a3a27078a79cdad24f31b"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "libx11"
  depends_on "lv2"

  on_macos do
    # Can undeprecate if new release with Qt 6 support is available.
    # Alternatively can just build direct X11 wrapper (libsuil_x11.dylib)
    # Issue ref: https://gitlab.com/lv2/suil/-/issues/11
    deprecate! date: "2026-05-19", because: "needs end-of-life Qt 5"

    depends_on "qt@5" # cocoa still needs Qt5
  end

  on_linux do
    depends_on "glib"
    depends_on "gtk+3"
    depends_on "qtbase"
  end

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <suil/suil.h>

      int main()
      {
        return suil_ui_supported("my-host", "my-ui");
      }
    C
    lv2 = Formula["lv2"].opt_include
    system ENV.cc, "test.c", "-I#{lv2}", "-I#{include}/suil-0", "-L#{lib}", "-lsuil-0", "-o", "test"
    system "./test"
  end
end