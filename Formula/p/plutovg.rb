class Plutovg < Formula
  desc "Tiny 2D vector graphics library in C"
  homepage "https://github.com/sammycage/plutovg"
  url "https://ghfast.top/https://github.com/sammycage/plutovg/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "4b08587d782f6858e6cb815b455fd7238f45190a57094857a3123883ecb595eb"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f327be8d935b5c4faad877a200ff94a386e5feacd8c13791d3e9fd6b73583c19"
    sha256 cellar: :any,                 arm64_sonoma:  "100256be4d7e09e6b551123a5588870dfd5ddcde762f38a2e97926cd100b41cf"
    sha256 cellar: :any,                 arm64_ventura: "49330df2058d1b41e8b9bdca2d2462ef8464d6c4e5e67ffb8926bcdb9592423f"
    sha256 cellar: :any,                 sonoma:        "7726c77de46ab5b02b36b08fd1678dd8fbba9ba5005062f7c008b684dfd44241"
    sha256 cellar: :any,                 ventura:       "32d1880e94e203077c43aa9e6533ec9fee7e1874627e943b55660c148ba5197d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e85aed0cca9388200d31f76fb16612241d95f117c4144241712d0cead336a6fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "980d47b6462ea6c98a045d6dfbab73a52f902cfbd8f3a1e89a1f7f7d44deb266"
  end

  depends_on "cmake" => :build

  def install
    args = %w[
      -DBUILD_SHARED_LIBS=ON
      -DPLUTOVG_BUILD_EXAMPLES=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    (pkgshare/"examples").install "examples/smiley.c"
  end

  test do
    system ENV.cc, pkgshare/"examples/smiley.c", "-o", "smiley", "-I#{include}/plutovg", "-L#{lib}", "-lplutovg"
    system testpath/"smiley"
    assert File.size("smiley.png").positive?
  end
end