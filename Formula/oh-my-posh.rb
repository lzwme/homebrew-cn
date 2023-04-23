class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghproxy.com/https://github.com/JanDeDobbeleer/oh-my-posh/archive/v14.32.1.tar.gz"
  sha256 "54c68ee6b362ce05f8094019e5f21a53f7d900e2e0b2b018abd7e17d636545c9"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cc1cf869fc11d6d34c1bed85b55e00951024c0376b336424f5979912cac1552b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3e23b44642b80b73445e294970be71ba250c44933aa881fe35343cc168b788bc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6e49b8cf31a35758a6c4b89fc9c2e15e39eed74af9e4c6e1253007c385a54f67"
    sha256 cellar: :any_skip_relocation, ventura:        "2c09a68f336ed7a820b611fc777d2e040aef2f89876319a1d6e3ebe726b47296"
    sha256 cellar: :any_skip_relocation, monterey:       "3e82641efa38cca9ff76a8b2fe3c2363c4a18609fb8bfb7741a59fd5124e5402"
    sha256 cellar: :any_skip_relocation, big_sur:        "5692517916405a53066268b111a62a8a6ea0ec47ad3ee02dd69eae47e08e02ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e74554ea9c52aedf69d7e1c707cfe85222c6ca7e32e4175cef7b4e5022719224"
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