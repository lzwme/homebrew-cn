class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghproxy.com/https://github.com/JanDeDobbeleer/oh-my-posh/archive/v18.3.4.tar.gz"
  sha256 "8534520f80f81be0c7c0ef971589177daf57b7fc29c294cab5d33e2ae782d4c6"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "76eed0e2ea96fe172e86d301ca6e407c8fb85de60412feaea0e9a99d54b4e488"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c9bdc8e20279352fef268dd8a65e9f39491f989a9b1b54e65f42a1230dff886b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e30ce6c9efdcfc572eccfa7bf5b6d30529a4ca80dead8fa1e5e9001b851cb1a7"
    sha256 cellar: :any_skip_relocation, ventura:        "91e9108c5c5cdc6694583152161843aae2edde00dc5adeb33a26b86b5cca160e"
    sha256 cellar: :any_skip_relocation, monterey:       "2fc0ff081ca8341ad4ae8b79fb0c10746ec53fab52ec82be524a03e8e6a0855f"
    sha256 cellar: :any_skip_relocation, big_sur:        "4a4cd93f8ec752f4eb62044c7e867cf6307dbf11cf800e500597e2fa553f92fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7b98617bc16c4d7cdb92633ba98c0e499cf36d69195b91397c7c7ea8178d523d"
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