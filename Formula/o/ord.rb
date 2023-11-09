class Ord < Formula
  desc "Index, block explorer, and command-line wallet"
  homepage "https://ordinals.com/"
  url "https://ghproxy.com/https://github.com/ordinals/ord/archive/refs/tags/0.11.0.tar.gz"
  sha256 "9715d3520abf4ec80cd16475752c996aec71938828d3844d6b876285f2fc45d8"
  license "CC0-1.0"
  head "https://github.com/ordinals/ord.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b32e6b1a8f7f1b4d2d4b251d459e7ada9e32991a50842d58659d896ee47f4d69"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "80930421ed7fd2d5b93a3f334f00343c090a827abd979d1ea24fc43979a96ea6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fe2912bfcd707363b5b9664529f2ddfc7a38e6c035feb6596f1db01456eaee1a"
    sha256 cellar: :any_skip_relocation, sonoma:         "b5ee7bc8f36470b20393c655d5f0adc1922248fa144b241328e6f83313230dac"
    sha256 cellar: :any_skip_relocation, ventura:        "5b689d02aa1c3f3833952d655baed21728ac7a93280c4f714df1a9d50716d11d"
    sha256 cellar: :any_skip_relocation, monterey:       "c4021dd167ba9cd295bbe86cdb92d5895d085d6f48662a4e50b3e4b03aae75f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0142145c0fac268911c5a590999b6c2b3e9b1f7779f2b2f2528358365876f006"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    expected = "error: failed to connect to Bitcoin Core RPC at 127.0.0.1:8332/wallet/ord"
    assert_match expected, shell_output("#{bin}/ord info 2>&1", 1)

    expected = "error: failed to spawn `bitcoind`"
    assert_match expected, shell_output("#{bin}/ord preview 2>&1", 1)

    assert_match "ord #{version}", shell_output("#{bin}/ord --version")
  end
end