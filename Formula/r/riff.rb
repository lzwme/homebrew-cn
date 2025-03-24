class Riff < Formula
  desc "Diff filter highlighting which line parts have changed"
  homepage "https:github.comwallesriff"
  url "https:github.comwallesriffarchiverefstags3.3.9.tar.gz"
  sha256 "bacb7f13aa2df28d44736b9454d7857cbc992164b6800aad37e3da03d34c1aa0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ed3e2d2ff03ae27f01f253066d1248bf82b45cf7ebb5cf968d1b88f79f79e132"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "049bc71cccdd32200085e2166978d264a6ab0aeb76dff58bad74f6e70a3216fa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a93c9c2d8a7b764426d3c87cfb408b76a573c4c68dfb5ca4af4c0919ac85439f"
    sha256 cellar: :any_skip_relocation, sonoma:        "2db4140d6ff93f5654c8b45e0947267a099fdfbeec89cd6f185dd4f4670ed7e2"
    sha256 cellar: :any_skip_relocation, ventura:       "1842fd68e32dcaa28dc8bd574d1aab32abb0fa0405c145b18e720d345efc4a09"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e9d86677b6d3bd236044f79180d8bbb70caa875b934f1a76590796f4670cfbfb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d728d7a8e3a9cb356d154293a2f444f908ff079848f8010a7f18d38ebc559c41"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_empty shell_output("#{bin}riff etcpasswd etcpasswd")
    assert_match version.to_s, shell_output("#{bin}riff --version")
  end
end