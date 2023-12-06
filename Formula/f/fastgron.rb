class Fastgron < Formula
  desc "High-performance JSON to GRON converter"
  homepage "https://github.com/adamritter/fastgron"
  url "https://ghproxy.com/https://github.com/adamritter/fastgron/archive/refs/tags/v0.7.5.tar.gz"
  sha256 "f2b29205659df3698b7b38848f4872a7b2b90f3faa4af1b4c4bdc218987d676f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d2f4a1d917d9bcd689284b386b688b0bce8da8b20f2281403ba3b3929ccbf689"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "922a2db9bd93579bb6400a07fc22414cd68d905aa577c99b7959c28d88a41d08"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f7012c964ef21ca2e8b48645640d2c8f519a8aa0d6894593d63a7dd967b8c619"
    sha256 cellar: :any_skip_relocation, sonoma:         "4e2ba2d16b619c697b8dd1fd733adae3a21172613e1757e4bbdc96b563b0ea4f"
    sha256 cellar: :any_skip_relocation, ventura:        "5ca0c212963e01717ba5fcdc17b15461a8cbee5f28e5eae72322836a90fe08d2"
    sha256 cellar: :any_skip_relocation, monterey:       "99f24237706527652519d8207788a2464718d4d2f882563f6284e4d999ce5be7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5f63f3234388c46a47e5f7ef22a558382882363cb2de2ef429227038d7b0ba09"
  end

  depends_on "cmake" => :build

  uses_from_macos "curl"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    expected = <<~EOS
      json = []
      json[0] = 3
      json[1] = 4
      json[2] = 5
    EOS
    assert_equal expected, pipe_output(bin/"fastgron", "[3,4,5]")

    assert_match version.to_s, shell_output(bin/"fastgron --version 2>&1")
  end
end