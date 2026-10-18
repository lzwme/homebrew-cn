class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://ghfast.top/https://github.com/twpayne/chezmoi/releases/download/v2.73.2/chezmoi-2.73.2.tar.gz"
  sha256 "0c137480901fae349ab8f1688fa881fd235d3708ac2ef5d800e0105d82632666"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  # Upstream uses GitHub releases to indicate that a version is released,
  # so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3df032e9e74f9066ddb06f7e03682a86ebc507087d8b0ebb7efc96f196ec66e2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c9869b9db02faef1d70f2fde8bc8520c3f3429756448c6d8c640e90136294b03"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "84d8da6e557918a9187e7a4d3bc44ee4196788b144ad3a4805c1a8016177b425"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7fcb9febddd99a4f49c03ad1b57ac7c4558ee1ba6c68176fe7c30e017c1f14bd"
    sha256 cellar: :any,                 x86_64_linux:      "d9c02e374dcaf6195f0fe34276217f3caffa397220a4ff821dd762b8ed54d3b2"
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