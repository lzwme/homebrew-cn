class Lunasvg < Formula
  desc "SVG rendering and manipulation library in C++"
  homepage "https://github.com/sammycage/lunasvg"
  url "https://ghfast.top/https://github.com/sammycage/lunasvg/archive/refs/tags/v3.4.0.tar.gz"
  sha256 "6ef03a7471fe4288def39e9fe55dfe2dbfb4041792d81a7e07e362f649cc7a0b"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "22b19736486a33a22e24d8b6cc2e45f9fba9feaef133edb96814ba9c204ecec9"
    sha256 cellar: :any,                 arm64_sequoia: "1ff9b9f2f594e1c8cf141fa90d223f3283b13af95043ffdb671a33a42a0d0b7a"
    sha256 cellar: :any,                 arm64_sonoma:  "f8c9ef612b737d65ef4401d10a0d25fc62b611c918e7b845d5de521af62af031"
    sha256 cellar: :any,                 arm64_ventura: "90562b856af604073882aa475c5b998bef521453cb286db2c91ade83cde2a223"
    sha256 cellar: :any,                 sonoma:        "d82949cc7da7957cf3ab92a2dce45539133459b5e7eec67205a5770ba208fe31"
    sha256 cellar: :any,                 ventura:       "d7fef0b651b7f83dc1f164d16f912d239fc20f6c2af2b344e79b04eb65d7392d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6cd0a09abe6f6aba32d13eaa01e57664f6579a035079da08afbb1114464b75e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9f6602b9ce23dfc850feed1aa0058276ae9cfb66f7a0168f230f47a8a219ea65"
  end

  depends_on "cmake" => :build
  depends_on "plutovg"

  def install
    args = %w[
      -DBUILD_SHARED_LIBS=ON
      -DUSE_SYSTEM_PLUTOVG=ON
      -DLUNASVG_BUILD_EXAMPLES=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    (pkgshare/"examples").install "examples/svg2png.cpp"
  end

  test do
    args = %W[
      -std=c++11
      -I#{include}/lunasvg
      -I#{Formula["plutovg"].opt_include}/plutovg
      -L#{lib}
      -L#{Formula["plutovg"].opt_lib}
      -llunasvg
      -lplutovg
    ]

    system ENV.cxx, pkgshare/"examples/svg2png.cpp", "-o", "svg2png", *args
    system testpath/"svg2png", test_fixtures("test.svg")
    assert File.size("test.svg.png").positive?
  end
end