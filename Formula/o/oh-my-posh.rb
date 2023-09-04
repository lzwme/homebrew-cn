class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghproxy.com/https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v18.6.3.tar.gz"
  sha256 "ef64a72c71bcd0b4ea1a2d68699e236bf4a245c1a00bb368c798908e695b4e05"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fd61c47a9bd0acb03909e74b3b9be8a5e1f578b2e21db4e52e18cf2a446049d5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8e70e2af5c9d4c62e8afd779cdf16b0bcbb86b693639c02cdc45415d4c87d4d7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a5fa6c8b951c221471f6644957763c76961f0aa80a4be868f111a72ff4c3c60a"
    sha256 cellar: :any_skip_relocation, ventura:        "10e867ab85c720208e2340ba6a18468a224861de8ed6a6856a28a84242888349"
    sha256 cellar: :any_skip_relocation, monterey:       "0b71bca7e0f796a08612575f8683f4c4c151347eb9dc601659c30bd07d22e097"
    sha256 cellar: :any_skip_relocation, big_sur:        "82e58c0dbba59834e88d9630e96332783fd4485809e6c5a19b80d9b62c7331e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8bad7611b9ab804f20c4dac7fd802258034cdf92f60c9b422c702cc743b46c4c"
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