class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghproxy.com/https://github.com/JanDeDobbeleer/oh-my-posh/archive/v14.12.0.tar.gz"
  sha256 "6cc4d0725aab37ef49686c6dacd978941aa06a9296f1d751d03aef268940cf21"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "63f506623f5d28227578f47dc558ef7defabb5a1ee69ac90a76b5e9518549610"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5893e2f6945745728ba46ab7fe96f761ecfb89b8afdc12005b74e75af4e7aef0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1cb08417e5610f64ba153fb6a815c263e051b58f4f30a2f2bc9d7436eb1a6581"
    sha256 cellar: :any_skip_relocation, ventura:        "2525117cdb075183c83c18fc7eb245847c7119b77a5b9ad02c882bd553429c0a"
    sha256 cellar: :any_skip_relocation, monterey:       "33f4b123de1501991941e574b2ca0bd07809a7500437d214399125b8f7f0ec47"
    sha256 cellar: :any_skip_relocation, big_sur:        "e2779d0f357348640b56b1580ae1cdc3b5aa93bd598f8a1a4c11fb473cb097ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c1224217e7543a2ac63419186a964435e9dfee2732fec334e57b62dcedb6fce1"
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