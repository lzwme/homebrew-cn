class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://ghfast.top/https://github.com/twpayne/chezmoi/releases/download/v2.73.0/chezmoi-2.73.0.tar.gz"
  sha256 "9311b05db8f302912b16f9a596456c13587d66ec78802cb13c7269928eea1abc"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  # Upstream uses GitHub releases to indicate that a version is released,
  # so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "27d840bc20b4dc85322d4f1f7605adac75e6ebe36f9c8b9b6001a4effe0f4969"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "30d2e84fdda98a8675b9adbd00476cd9c1bef7d1af6a9f818badecc5da9750b8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b36eac1254af4ed38e9ee1606bb9f1f601240e07c7402ddda668ab573b6db7ee"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "922bb3b71a8876c0f4904993c0461735a19cbd3ed25a3fff843bffb34e0f9a8c"
    sha256 cellar: :any,                 x86_64_linux:      "18156ad7ff8f9c8c6246cb894d890795c1fcc2b1a5d98ee089798dbc4118e531"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser)

    bash_completion.install "completions/chezmoi-completion.bash" => "chezmoi"
    fish_completion.install "completions/chezmoi.fish"
    zsh_completion.install "completions/chezmoi.zsh" => "_chezmoi"
  end

  test do
    # test version to ensure that version number is embedded in binary
    output = shell_output("#{bin}/chezmoi --version")
    assert_match "version v#{version}", output
    assert_match "built by #{tap.user}", output

    system bin/"chezmoi", "init"
    assert_path_exists testpath/".local/share/chezmoi"
  end
end