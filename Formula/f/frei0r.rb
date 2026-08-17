class Frei0r < Formula
  desc "Minimalistic plugin API for video effects"
  homepage "https://frei0r.dyne.org/"
  url "https://ghfast.top/https://github.com/dyne/frei0r/archive/refs/tags/v3.3.0.tar.gz"
  sha256 "4cf2b085f437e42ba123e31f941ce3a8eb579e271c93880614239b741d74b156"
  license "GPL-2.0-or-later"
  compatibility_version 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "14e7dcb0a596a861d27acd6e00660128a192ce5c42365b6118353e33847cc419"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d5477c1ae673055cc97615903b9385044f66bc65ba16eae333866767e23be810"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4ef1fd07e16bcfd8857569e6da1ff162d54a12b88d65fdbb7fe69a81f581e1ca"
    sha256 cellar: :any_skip_relocation, sonoma:        "d32a134c00573354f1a5d6927d498c7aa252ff2b1994d99dabe14fa357dcbc8a"
    sha256 cellar: :any,                 arm64_linux:   "d2edf091bf4462c71e97e4c714caddfc9373c525615ec71c13e8d5ec17818a02"
    sha256 cellar: :any,                 x86_64_linux:  "b3b3d86b29d440607ce9ea610d0b2c5b966452782469d7546d051894e363ac2e"
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