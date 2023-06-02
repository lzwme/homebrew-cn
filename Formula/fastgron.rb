class Fastgron < Formula
  desc "High-performance JSON to GRON converter"
  homepage "https://github.com/adamritter/fastgron"
  url "https://ghproxy.com/https://github.com/adamritter/fastgron/archive/refs/tags/v0.4.8.tar.gz"
  sha256 "ee028cbf47813f65f08c37a4746c88bd0e326928893815d98c08720e2e3980b1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4efb9be96d01388074dcc47bf2166ec89418fdc41bb56e52b63f459cbffa92ff"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c44c0c2d31703f90ebe0104375603176611a6e4790b1fc89e2194e640e49ac5d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "234fcaab06ee5a5fb7a2ff583b06852f1426f785d59668a70db9c22f66eb8c28"
    sha256 cellar: :any_skip_relocation, ventura:        "a49d26f75309481f340431ac7f2d40ac5f23d7d8e3b13e05eb08d4c75c0ff914"
    sha256 cellar: :any_skip_relocation, monterey:       "c74c51faf8426931aedfcd4251b9c6781b2e40f8d4b8c6073efab667f955b353"
    sha256 cellar: :any_skip_relocation, big_sur:        "56ecfc0e4642da5621ee6cbae68df9a8bcb9cc780b15fcc1283e625913839a21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e2fdcaa052e016bb8903b1408e428b46184cd3125a9ac06a433a63d71fe21437"
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
      json = [];
      json[0] = 3;
      json[1] = 4;
      json[2] = 5;
    EOS
    assert_equal expected, pipe_output(bin/"fastgron", "[3,4,5]")

    assert_match version.to_s, shell_output(bin/"fastgron --version 2>&1")
  end
end