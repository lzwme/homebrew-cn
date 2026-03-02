class Gerbv < Formula
  desc "Gerber (RS-274X) viewer"
  homepage "https://gerbv.github.io/"
  url "https://ghfast.top/https://github.com/gerbv/gerbv/archive/refs/tags/v2.11.0.tar.gz"
  sha256 "907ee7764e2d048b09ddcd8291bdb48d7b407056d558f5bf7164a09b6e68895f"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_tahoe:   "adb953bf525d27778a9656331a20868a53debea7e97c90a938bd4554e28a2fc8"
    sha256 arm64_sequoia: "b068bdd2f8b5424eb9d4f0f813a5c8401d681259bc6faeb0ce762fc65eb9c1a9"
    sha256 arm64_sonoma:  "3280fbfe1826a221a92435df889a15b678764702ff1bdce7e39f6827d770c356"
    sha256 sonoma:        "662c7d8bd218050a8ba39e3d8f61c8507b98e2425870d63a70762ce9d5459157"
    sha256 arm64_linux:   "0e7e2d92256b3d69ba3b997d248c33de94899c46d33a1aa991fe7f4981383851"
    sha256 x86_64_linux:  "ce936699c7897c12a68c39422650f26b79a7d48053f23a1e6f5b1b1754557d99"
  end

  depends_on "cmake" => :build
  depends_on "gettext" => :build
  depends_on "pkgconf" => [:build, :test]

  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gtk+" # GTK3/GTK4 issue: https://github.com/gerbv/gerbv/issues/71

  on_macos do
    depends_on "at-spi2-core"
    depends_on "gettext"
    depends_on "harfbuzz"
    depends_on "pango"
  end

  # Backport CMake fixes, upstream pr ref, https://github.com/gerbv/gerbv/pull/303
  patch do
    url "https://github.com/chenrui333/gerbv/commit/13e73c2767f0170cd4ff660ba0ccceac7c080573.patch?full_index=1"
    sha256 "d1e8adc4371cfa3b2cc033b06c26daf2aa219cdd8d7a58b3fadfbdc0cbf9f920"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    # Ensure generated gettext sources exist before parallel translation build.
    system "cmake", "--build", "build", "--target", "generated"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # executable (GUI) test
    system bin/"gerbv", "--version"
    # API test
    (testpath/"test.c").write <<~C
      #include <gerbv.h>

      int main(int argc, char *argv[]) {
        double d = gerbv_get_tool_diameter(2);
        return 0;
      }
    C

    flags = shell_output("pkgconf --cflags --libs libgerbv").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags, "-Wl,-rpath,#{lib}"
    system "./test"
  end
end