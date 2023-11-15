class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi.git",
      tag:      "v2.41.0",
      revision: "4a5f006fede66f8e2b9213bfe872244eb2b2cfd8"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  # Upstream uses GitHub releases to indicate that a version is released,
  # so the `GithubLatest` strategy is necessary.

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8f51f93887f3789abe40a338e1e02bc7ab266d92df0bf17603425ecc6f00b97b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1b4decbe92239219ae890e237fe374c523ec51010a6ca4d1f9cc306587ff7f25"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3753915733551af4a6106304322c2df648ae9f47977a9be66e8dde8b94b0e757"
    sha256 cellar: :any_skip_relocation, sonoma:         "c1b0a611a38dfc4cf17680422bb774a1dc8df42d69ea57efce8813cd40657e4a"
    sha256 cellar: :any_skip_relocation, ventura:        "5296ebafbdf335a6e9047e532b7468fd73e94a447e9c415ecd553dac53cc41dd"
    sha256 cellar: :any_skip_relocation, monterey:       "a7ea6c438261ed9618c6a31d9448378a16ea2590512408aa48bc53ec671b443f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c58019477c55a52e24e53095c42609577146f885aaadca4e429915892d3b187"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
      -X main.date=#{time.iso8601}
      -X main.builtBy=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    bash_completion.install "completions/chezmoi-completion.bash"
    fish_completion.install "completions/chezmoi.fish"
    zsh_completion.install "completions/chezmoi.zsh" => "_chezmoi"

    prefix.install_metafiles
  end

  test do
    # test version to ensure that version number is embedded in binary
    assert_match "version v#{version}", shell_output("#{bin}/chezmoi --version")
    assert_match "built by #{tap.user}", shell_output("#{bin}/chezmoi --version")

    system "#{bin}/chezmoi", "init"
    assert_predicate testpath/".local/share/chezmoi", :exist?
  end
end