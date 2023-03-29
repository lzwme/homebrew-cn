class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghproxy.com/https://github.com/JanDeDobbeleer/oh-my-posh/archive/v14.21.0.tar.gz"
  sha256 "4e34ddfaa9670b4b05f876ec1cd4976df0e6794b44d01b61b414cf435502386c"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b145fd49c553812803d6d7160ad1f97c3579a44a2cc193a9992f11becf3c5c79"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d227d5f9a4a78cd4b56dc204b23b2614d2cf6f0f007956b45a91d9367dd4f2f6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4d825990748b11da410afd6a61c4548d9ba154ef0515c9f5d18acc7c38402074"
    sha256 cellar: :any_skip_relocation, ventura:        "519f33cb3edf91c0dd78e23e5c715581ef582a3cf8eff9ecbbeb5b09ba7bcf15"
    sha256 cellar: :any_skip_relocation, monterey:       "ff795b968b54149aebc7a40bdc5cccf81f44517f602365774105dc64a74c0772"
    sha256 cellar: :any_skip_relocation, big_sur:        "4c57b51158b54d929facbd8c261497f4fe124ebc2d9a6e2daa09189c8dd92587"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7003a702f7f6fa5f628267829016b3208b892a38928622020df64d51898ffc1c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.Version=#{version}
    ]
    cd "src" do
      system "go", "build", *std_go_args(ldflags: ldflags)
    end

    prefix.install "themes"
    pkgshare.install_symlink prefix/"themes"
  end

  test do
    assert_match "oh-my-posh", shell_output("#{bin}/oh-my-posh --init --shell bash")
  end
end