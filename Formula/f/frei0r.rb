class Frei0r < Formula
  desc "Minimalistic plugin API for video effects"
  homepage "https://frei0r.dyne.org/"
  url "https://ghfast.top/https://github.com/dyne/frei0r/archive/refs/tags/v3.4.0.tar.gz"
  sha256 "22ac75376236f75df6e2d17bb84ce366b93d80f01f9ac1c5b1810eefac940b3e"
  license "GPL-2.0-or-later"
  compatibility_version 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7e92a75da32424fe3f5559a650511a8bc80872332134fa95cbb36ae45cb4f9b5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d5fe10a29c1a70472753eb7169863e9058996b14d381e10dcfc4d412afa276f0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "120d6cf5cec9c072941dee9a1f42c87577907b043559de3c754871ed237c7d25"
    sha256 cellar: :any_skip_relocation, sonoma:        "545afaa3f3729c905d8246efe771cefac0f01dc3a5928b29aef1e944d68f16bb"
    sha256 cellar: :any,                 arm64_linux:   "901e32a46dac71d5879455dc2cba6f82d6b6eea5376ce624a824c379027ea7fc"
    sha256 cellar: :any,                 x86_64_linux:  "3fc99b2ccc1d88ec6bcbc285a161c98c8e57f1d9fe8a3e219fe970690eab255e"
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