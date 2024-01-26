class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https:chezmoi.io"
  url "https:github.comtwpaynechezmoi.git",
      tag:      "v2.46.0",
      revision: "1418f74ab40bbee807a1438ec0bbdb6c85f24a74"
  license "MIT"
  head "https:github.comtwpaynechezmoi.git", branch: "master"

  # Upstream uses GitHub releases to indicate that a version is released,
  # so the `GithubLatest` strategy is necessary.

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "33068d676bb06fd785aa33ef8bcdbe06a49accd7c65b023d99aeef34627e6580"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5a2d1d9ab6759ea6158f3afcfee3cf362fa2916565034bcc2ac857a7219308db"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "49fd16e1e3a487d8234bd7373b7012a70d2e7140a02ee5a7d318cc3543a159c0"
    sha256 cellar: :any_skip_relocation, sonoma:         "bc3ca2c68a434e340b21f78a819485ba754a11d606a7bed508974dd6dfb988cb"
    sha256 cellar: :any_skip_relocation, ventura:        "610c448a86433a636c977395cb069ef92f7b9a4543b59b19943ea4174c32cbe5"
    sha256 cellar: :any_skip_relocation, monterey:       "e209342ad90c640330ab349af7d48d63eacc1fe6bff9c9070d48f8f74acf999a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "30efff1edbd838d02ba85bac50b82821d0d5bdc8481bc7fd4ebb3b69bddb6ef0"
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

    bash_completion.install "completionschezmoi-completion.bash"
    fish_completion.install "completionschezmoi.fish"
    zsh_completion.install "completionschezmoi.zsh" => "_chezmoi"

    prefix.install_metafiles
  end

  test do
    # test version to ensure that version number is embedded in binary
    assert_match "version v#{version}", shell_output("#{bin}chezmoi --version")
    assert_match "built by #{tap.user}", shell_output("#{bin}chezmoi --version")

    system "#{bin}chezmoi", "init"
    assert_predicate testpath".localsharechezmoi", :exist?
  end
end