class Fastgron < Formula
  desc "High-performance JSON to GRON converter"
  homepage "https://github.com/adamritter/fastgron"
  url "https://ghproxy.com/https://github.com/adamritter/fastgron/archive/v0.4.13.tar.gz"
  sha256 "8a7c48c1f96a97662aaf38e623655a85d17561740892b671fa6c29d1b7a5b27d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "928602980c2082d95c130076631bc8d51ce5791250722199efa0e549b4c7d6b0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f08bb78c38cb6c9e71c1834b8ee6d54770b3cd49d7f0573d7ea311539efb60a7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a0b463456398de7aebdfb03a72bb7850630ea54e7b1788cfb8ab6a1681cfa087"
    sha256 cellar: :any_skip_relocation, ventura:        "4029f00e9f9ec706f0f99577629d68da51bda3e484f20095404d659705c09fba"
    sha256 cellar: :any_skip_relocation, monterey:       "17817134fa51c8447bdc86f310d345df44d043a9e7fd8a3717f11e1bb8829a7b"
    sha256 cellar: :any_skip_relocation, big_sur:        "6fdba0a449eef87d58f19925f04e6695c7c41d464297a426a7ac8b56da23a3b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "38d5b4df8c54bf04f3f92a0d6009905d8e426afe8c50b6243f3fd4723a05c499"
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