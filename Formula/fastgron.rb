class Fastgron < Formula
  desc "High-performance JSON to GRON converter"
  homepage "https://github.com/adamritter/fastgron"
  url "https://ghproxy.com/https://github.com/adamritter/fastgron/archive/v0.6.3.tar.gz"
  sha256 "389407e64a768237e2397ba9303adb8bf602ba2b1cdb13eda5d988cfd0bc716c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9b28e86dc98e5d9b399db599c353a5e66a7adf08ab5997bf7cbe643a7af489f6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8b33722b5e58a1f9d9495275e28dc90920133c1cdc48cfbbc0bfe7c604d83d58"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "48a23f8c47061f628ff0af9dcbf8252c572bfdaf77f5029b77a646efaf89fb21"
    sha256 cellar: :any_skip_relocation, ventura:        "0634b88ba8cfc8ab2eaa74b0a785d89c25ff08f3ac01f73cc94831c3745155ec"
    sha256 cellar: :any_skip_relocation, monterey:       "39cf2364b762ca5e062466f8b7c1bd48eaea86cfd5eb50f1c5a0bc4148b606b7"
    sha256 cellar: :any_skip_relocation, big_sur:        "ee34ae895f8c48542a2c6e9368ac4ac0f7099b773c3f69910ee2ef0346e44eb7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dcf8718bab1254bc2e8488869cf8851b52ec7161efd98cf96926b35e252730c1"
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