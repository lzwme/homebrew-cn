class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://ghfast.top/https://github.com/twpayne/chezmoi/releases/download/v2.70.4/chezmoi-2.70.4.tar.gz"
  sha256 "a70137b51f83a894d113b64d67095ca8d5609cbe783b9ea9fb72fb77b80bff4b"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  # Upstream uses GitHub releases to indicate that a version is released,
  # so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "867d684e7322e34fc0ae0a0afdad89a8be346702387f7ad12f9699e56980ecab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1f5941f5cfc9a739847b28975c4de04019fbd8f8587d97775172a281f1b7630c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0552c76ae3511f2d27a62fddf6998f6487c8060027471657125d6b59edac96b5"
    sha256 cellar: :any_skip_relocation, sonoma:        "5b4e1e6235d3134664de30686bed0808dc04239c9a6bc70cc6cb2d975d76b2b2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a09f16c389f4508d9a5656cad4ccf8cca1590c5548436597e51669dd5a220075"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aa5a4b157830dfde99af18785deb541d569e1c3fea8a64613a311aed836bf044"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{File.read("COMMIT")}
      -X main.date=#{time.iso8601}
      -X main.builtBy=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:)

    bash_completion.install "completions/chezmoi-completion.bash" => "chezmoi"
    fish_completion.install "completions/chezmoi.fish"
    zsh_completion.install "completions/chezmoi.zsh" => "_chezmoi"
  end

  test do
    # test version to ensure that version number is embedded in binary
    assert_match(/commit [0-9a-f]{40}/, shell_output("#{bin}/chezmoi --version"))
    assert_match "version v#{version}", shell_output("#{bin}/chezmoi --version")
    assert_match "built by #{tap.user}", shell_output("#{bin}/chezmoi --version")

    system bin/"chezmoi", "init"
    assert_path_exists testpath/".local/share/chezmoi"
  end
end