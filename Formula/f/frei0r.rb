class Frei0r < Formula
  desc "Minimalistic plugin API for video effects"
  homepage "https://frei0r.dyne.org/"
  url "https://ghfast.top/https://github.com/dyne/frei0r/archive/refs/tags/v2.5.2.tar.gz"
  sha256 "fa6abb2a1e86cec4972f9dc891a4953c35d716a72b860c67888a26bbf1877862"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ea11fb8efdb014de4c3732f08ac31fc423823c6c3dd3e11f37acdcb409c04311"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2004362d29971741ca941b33ddc590d246f3720ef3b2b24690ba06fecd06c2f8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "97c070dfe96e1aa03b6ccf74d72f7749708ca2fb546bf6da8557ae4d30a1b85e"
    sha256 cellar: :any_skip_relocation, sonoma:        "17f9ee3587537d369b1d745d398999957c54c15ee3ae28da5ca567278b87b516"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5db45efff296814eb9804291e75839b6c8502b2f730b6a44ab530594427c19e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5926e1f91ffb437b53315cec33a3b7ad058a9d9cf3f7f8b078dd4c8395df3899"
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