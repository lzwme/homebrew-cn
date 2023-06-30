class Fastgron < Formula
  desc "High-performance JSON to GRON converter"
  homepage "https://github.com/adamritter/fastgron"
  url "https://ghproxy.com/https://github.com/adamritter/fastgron/archive/v0.6.1.tar.gz"
  sha256 "f1977f0a8ee7fa0ca0c2cfab6f60f7c4a28a464dbdfce5b6bff48a52a4df427a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2288f12e1d0d6729e4e94e9dfa89f9e985117a86efb694fad0e7e48faaf875de"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e1870323ca659724b61932dc16825ac693723ad02dce47a2fb33c4a7b0131db7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8965cf52126bef61e8edfcbfa43a4e7f545182753586e46b73b13504f8682717"
    sha256 cellar: :any_skip_relocation, ventura:        "bad5ca7fe6bb1f3e8d327043b6d5fceafcbef788aae58c6e99509311b3d71769"
    sha256 cellar: :any_skip_relocation, monterey:       "6c5b6173609ef8a1ca32bc9c76f248eac90f3375524cf0b37beef97e2ec72f60"
    sha256 cellar: :any_skip_relocation, big_sur:        "c2d77a7480c23064a8e4fcb3a9ceff0ce7ea458561bdc1df613842df9d65c0ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5325ab342dc252195a5914125200395e42a42342dc906673ccae75a6910eb86e"
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