class Orc < Formula
  desc "Oil Runtime Compiler (ORC)"
  homepage "https://gstreamer.freedesktop.org/modules/orc.html"
  url "https://gstreamer.freedesktop.org/src/orc/orc-0.4.43.tar.xz"
  sha256 "82394e20e5c4dffe8b45ea8525c62dd4e3e8be7f253ac11c19297ba7ea5473e0"
  license all_of: ["BSD-2-Clause", "BSD-3-Clause"]
  compatibility_version 1

  livecheck do
    url "https://gstreamer.freedesktop.org/src/orc/"
    regex(/href=.*?orc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "e329172340cf223077ac19ca64c9de1151f2cd70f6fa80a5c6f3e69a108d1a7b"
    sha256 cellar: :any, arm64_sequoia: "d6858cbca62184f1e2eb4fae6b5c8dd877b0febfe61c1c834427481805ce242f"
    sha256 cellar: :any, arm64_sonoma:  "760744ee7c33e20b65f7673e254ffa141edaa5b02d00392e0c8b6527e136dd40"
    sha256 cellar: :any, arm64_linux:   "da2a1a311fce9111c9af82f96348fbd8f398b6436487dfb1cfac72cfc5f9dcd5"
    sha256 cellar: :any, x86_64_linux:  "824cf43e0ada73a3476e79fb89f6926f0d2562dd717e2aef7da37c7cbb12a0c0"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/orcc --version 2>&1")

    (testpath/"test.c").write <<~C
      #include <orc/orc.h>

      int main(int argc, char *argv[]) {
        if (orc_version_string() == NULL) {
          return 1;
        }
        return 0;
      }
    C

    system ENV.cc, "test.c", "-I#{include}/orc-0.4", "-L#{lib}", "-lorc-0.4", "-o", "test"
    system "./test"
  end
end