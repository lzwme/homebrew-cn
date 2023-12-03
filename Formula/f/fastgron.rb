class Fastgron < Formula
  desc "High-performance JSON to GRON converter"
  homepage "https://github.com/adamritter/fastgron"
  url "https://ghproxy.com/https://github.com/adamritter/fastgron/archive/refs/tags/v0.6.5.tar.gz"
  sha256 "6211faf07b62f08ffbd2714f94787c7e375815162590a5a4f5c8f3b161057525"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "438774759d57417d976e0b80a8b8b985d364ae8e9bdd12f586c746e2b286f394"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5d73b195a53d17d280859b290127236046cfc5304ac9f59acfc32af8132e255e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d17d2eb86dd1ca8a1f0a300f3af88efa46b7c087bacc94b8c2eab6e5833b2ab7"
    sha256 cellar: :any_skip_relocation, sonoma:         "421f24c0fb1dcb6db18de43e4e7d14fcd082f0ad4294a9fd5f5bc67761c24a11"
    sha256 cellar: :any_skip_relocation, ventura:        "c4dfaf8a2244c215c1055c7e36ce3a3a0dd82bdeb116f609648ea978de4848ee"
    sha256 cellar: :any_skip_relocation, monterey:       "c8fab1665e83c3525aee6f39022b718188622482e8594c65a359489421008373"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8bb583e44646b00706aba65cb5815a87d89e21549cb956f5fee94e81dc8c7dc4"
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