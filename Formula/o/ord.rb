class Ord < Formula
  desc "Index, block explorer, and command-line wallet"
  homepage "https://ordinals.com/"
  url "https://ghproxy.com/https://github.com/ordinals/ord/archive/refs/tags/0.13.0.tar.gz"
  sha256 "d4b4e0b347e54a5c0e9827486c5df9234d899ddadc311df4a147d9bf1877ad7a"
  license "CC0-1.0"
  head "https://github.com/ordinals/ord.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8e4bd526f18c63f45c5113956b1d1fc23c64f646806b2fd53f82b1fb04084a04"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "364fa9e97ed0c5e1634ceb8bb2f6a0056a71aff4377270ba7cc439314d42bd3b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8cf503a9d36b56f055a2f4726be4eeb6a73479ea3095904d63771de7a53d317a"
    sha256 cellar: :any_skip_relocation, sonoma:         "825f4c6c9569825d74ba7c34e4c435029b8607e1d159c71f8510fca352db61cc"
    sha256 cellar: :any_skip_relocation, ventura:        "bf658581dd848ac8f8a00ff48f420e5a0703a41dcc81d0aa561d38ce937b4eb5"
    sha256 cellar: :any_skip_relocation, monterey:       "056ffd341fb58a6e1a3b221b4d8ef959dc5577c76564fb3e399b6eb95335cf8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "79b41b5f5bc4cc10ca7c7c626c55ec83d8c392f4351905336705bf139c845e58"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    expected = "error: failed to spawn `bitcoind`"
    assert_match expected, shell_output("#{bin}/ord preview 2>&1", 1)

    assert_match "ord #{version}", shell_output("#{bin}/ord --version")
  end
end