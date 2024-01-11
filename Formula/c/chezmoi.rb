class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https:chezmoi.io"
  url "https:github.comtwpaynechezmoi.git",
      tag:      "v2.44.0",
      revision: "9902245adf529f5617dd1606a08f53f1fb1e8fa9"
  license "MIT"
  head "https:github.comtwpaynechezmoi.git", branch: "master"

  # Upstream uses GitHub releases to indicate that a version is released,
  # so the `GithubLatest` strategy is necessary.

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "105b4edd2fe54bd23dd36af8f057e6ea1a1e4c90faf0256267bed3bf5c1c7495"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9fcf3facc6e9c9ab98ff6641dcdb32217dd358255717f6064221ae4992bd1196"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fbdaf4ceb1de9cef36bda20044d888990a968b6eead2dee0e55bdcf527ad6e20"
    sha256 cellar: :any_skip_relocation, sonoma:         "0b9950c219df64136b7ad8b01cc869ff8cd58540c0da67934653457e6c7ec11f"
    sha256 cellar: :any_skip_relocation, ventura:        "c6273cc32b6c949e18b07a7ac54dea0f8fd9e60a4b687cbd43f6410c78e3329c"
    sha256 cellar: :any_skip_relocation, monterey:       "af45767870f18ac9ca781ac5c9fcce22d10d7c003e72b9c9387fd4b7d2d2da29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4b23e0e7bb23b7393d22c69597d17703cc612f90259353ad7b8487ca3a07478b"
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