class Fastgron < Formula
  desc "High-performance JSON to GRON converter"
  homepage "https://github.com/adamritter/fastgron"
  url "https://ghproxy.com/https://github.com/adamritter/fastgron/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "2f54a7d09dc814db4c432ead04bab7450f6ec4dc45ac9ad6c269d3ba6d74c13e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "84190f08530578d3ed974ab61092f8ef0f5dfb0fd36a09e7c9de173d1e348ded"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "501751a619efc80ee2f6b2502e2a07fd5fdbae125b107af7dc15244df87c5c89"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c9113252dcc5318a5d6a38cfbea257ae878bfc52c59338e35c01b63bf2add9b2"
    sha256 cellar: :any_skip_relocation, sonoma:         "f2c1e892ef6cc306689b26389cad3189eba95fe84eef7bbba745cadecb44efa5"
    sha256 cellar: :any_skip_relocation, ventura:        "dbf797a5af1e6b16f5a5b24569a71bb85850958f942a3ede3830cc298fa5a298"
    sha256 cellar: :any_skip_relocation, monterey:       "f38dc0c9befe3752e33ff219ca990d49c81968aacfaf2ce10fac65d2332dc862"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "042248f1284342495bed367175182630a191dd756be708f3fb1333465dff9d1b"
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