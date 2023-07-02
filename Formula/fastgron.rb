class Fastgron < Formula
  desc "High-performance JSON to GRON converter"
  homepage "https://github.com/adamritter/fastgron"
  url "https://ghproxy.com/https://github.com/adamritter/fastgron/archive/v0.6.2.tar.gz"
  sha256 "3a2fc4af743a6479eb56bd536693e55d4be542f1125cddf3f4b753394d11a12e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5418ddff61b2d7f89a3d805e1a11e8f2811f6127f89f4a84c4e6f6fffccdf21f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2b329a48d7464424f311d8d7eef32bb2af1171933fe05cc7bb261f462cff7b4c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6fd8f081298c969d123f2e1b25c2af45a33646f16335112a9d3bf3f3c6ba18d0"
    sha256 cellar: :any_skip_relocation, ventura:        "92bbe3c94fe013c815beb2832f0e3faf1e8c70ea7444f52b97f8d764e5a5ad6c"
    sha256 cellar: :any_skip_relocation, monterey:       "dcc0301e38bb3bef9e5ded67bd0dd20f055420222291c4f02f36beb59fac449c"
    sha256 cellar: :any_skip_relocation, big_sur:        "0acec372dd41e7a593f8c324348b3c0d70311b9afc94877ce187f1faf4c3441c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "811adc5f08806b07ae6220b78aacd88b9813e8273041e51fa6f3e9b9d842db3f"
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