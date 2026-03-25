class Frei0r < Formula
  desc "Minimalistic plugin API for video effects"
  homepage "https://frei0r.dyne.org/"
  url "https://ghfast.top/https://github.com/dyne/frei0r/archive/refs/tags/v2.5.6.tar.gz"
  sha256 "bfe715df3d33c1acb857732962402bb8b0eef73e9dde1b58485d3e3b0e42e182"
  license "GPL-2.0-or-later"
  compatibility_version 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "90e250739d6a8fedbbba1ef4800350f6a0ff6d3d86102273544ecc2d14cccedc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a99cacf361ef04dcec595f1faa2a88180502e23b3cacc823f4f67cbb5cfa4b5d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "de8754332469b1fa82614a20563b89037ccd674aef45cc80fc437217e18676ed"
    sha256 cellar: :any_skip_relocation, sonoma:        "433a2abc4c6a8d13fd382f42bc4104f593d29397e48155f6b0d6989d5fcd7ca9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "405fb35048d0586f0689a12339e974303431e14c520d6a8c5a0a5e54a290bece"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7437c3c0c632a4c78c4b9af4ee8d6d22c661c03fe61db375b3f39c3b3777c369"
  end

  depends_on "cmake" => :build

  def install
    args = %w[
      -DWITHOUT_OPENCV=ON
      -DWITHOUT_GAVL=ON
      -DWITHOUT_CAIRO=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <frei0r.h>

      int main()
      {
        int mver = FREI0R_MAJOR_VERSION;
        if (mver != 0) {
          return 0;
        } else {
          return 1;
        }
      }
    C
    system ENV.cc, "-L#{lib}", "test.c", "-o", "test"
    system "./test"
  end
end