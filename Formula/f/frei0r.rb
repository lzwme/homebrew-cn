class Frei0r < Formula
  desc "Minimalistic plugin API for video effects"
  homepage "https://frei0r.dyne.org/"
  url "https://ghfast.top/https://github.com/dyne/frei0r/archive/refs/tags/v3.1.2.tar.gz"
  sha256 "2c848c6022a0f1b02be0568b99c7c353df82700235e85888f31ca97efded391c"
  license "GPL-2.0-or-later"
  compatibility_version 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f6358db222a7e050ff440b7905a76a530c636ab9905b738c0a09c3b62c63085d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cdbb75ff946cf65a3364f75ee7a084fa504ccf0138f6ee46780761287f3dfab0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2cdb1e9d798da45cd894f52fb68f869ae6e8c84513c8a3ab92b3cccb91bddb08"
    sha256 cellar: :any_skip_relocation, sonoma:        "be7b1dd96428a8fc9962d84ea9507c4993f71ae981dd86d60053c124fba3f8c1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "25d13dc3280774ab211dc92ec35a4911341adaf5fb8b2678032fbf5faf090bb9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ace3980c3a4c6d929ef440351b149342adc1a481ddb790911256f232d7190516"
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