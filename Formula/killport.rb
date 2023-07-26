class Killport < Formula
  desc "Command-line tool to kill processes listening on a specific port"
  homepage "https://github.com/jkfran/killport"
  url "https://ghproxy.com/https://github.com/jkfran/killport/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "3ff4fd79006f42b2ed89ff26fc87a36d505880de6b208686a4699ab9434a0811"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "656ad2085a5900266711e18d63f45aa73543cc460d0ff3f76bcd2856a3b31cf7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "730b414e6709ed9c9cab171294506ac310130b284058c85b4380595845437f2d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "82d44180f9ede5c2ca01884ca884720eaa1be7238d88b05f6e6efb9e2c85074a"
    sha256 cellar: :any_skip_relocation, ventura:        "9cc8160bcb39d47ac8a56b78b47813daf0f78efeac0f4284a702832635867985"
    sha256 cellar: :any_skip_relocation, monterey:       "7ee212c19bc85fb25ba14ee46ea37b3b3d2dc2b61ac88405899ddb9de07ba05d"
    sha256 cellar: :any_skip_relocation, big_sur:        "de38c357764a51a51bae2c0e2f1275ffe0b5d1289a07e98a51135f84f8476891"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e5a0b803ae3f17165ff5e0d4b0f88ffc3f83164926ff4fbd147e65668ed32912"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    port = free_port
    output = shell_output("#{bin}/killport --signal sigkill #{port}")
    assert_match "No processes found using port #{port}", output
  end
end