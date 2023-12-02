class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghproxy.com/https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v18.28.0.tar.gz"
  sha256 "7e89ff64a0d4a84e8558cdacb6623d53b5db8bc808978040761403d46886bd60"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a8824026989fd5a2bf34236dc00bae52dd0476f4dee88a3727ba54440e36eb6a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ccfa469546657f81a3f9a1be11a14ee9b582cfe6e8cd6f6b270a669d64636bc7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e2bbd3dafc4156ee1318f776f430b55f414a7e26b351114acfedc295eb1c6140"
    sha256 cellar: :any_skip_relocation, sonoma:         "62f99b2f538a61bd8bdc72eb6f1ac8752582752d2c0f880db193d7681e242947"
    sha256 cellar: :any_skip_relocation, ventura:        "dbf7b8785b27663e4f6bb5f88622b1808fe0398e53038f6e84234277fb65c08f"
    sha256 cellar: :any_skip_relocation, monterey:       "4c240ba2c27a39b481ebe2904cf400499fbb07d5a468b4307c06daa0b03575ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2e8f9937b44ab928a29d6ccaf2e4a447924c544f59a91e3e30302109e2bae9d7"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Version=#{version}
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Date=#{time.iso8601}
    ]
    cd "src" do
      system "go", "build", *std_go_args(ldflags: ldflags)
    end

    prefix.install "themes"
    pkgshare.install_symlink prefix/"themes"
  end

  test do
    assert_match "oh-my-posh", shell_output("#{bin}/oh-my-posh --init --shell bash")
    assert_match version.to_s, shell_output("#{bin}/oh-my-posh --version")
  end
end