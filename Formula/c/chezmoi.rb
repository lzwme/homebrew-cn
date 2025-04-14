class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https:chezmoi.io"
  url "https:github.comtwpaynechezmoireleasesdownloadv2.62.1chezmoi-2.62.1.tar.gz"
  sha256 "8633c1f1bd0b46ec5c5b621fd51e63bbb03d02f60d23e760783258813d3bf475"
  license "MIT"
  head "https:github.comtwpaynechezmoi.git", branch: "master"

  # Upstream uses GitHub releases to indicate that a version is released,
  # so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d42d2699902a903ee1d24818c5bcb83f8c21f043789a68ce5edbbe86332b2d30"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d368c910e3070e3d59e4994dd5f8fa580ea60a6e2029e858f6e62874f44c798f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4fca215fdaa89a01b45c23280caea8fc1c014655b2df3209ee4a1714c0c9771d"
    sha256 cellar: :any_skip_relocation, sonoma:        "d7c6cd34f0976ad8347b3467454e2f6a915deb0e2f3069791495ec68da2d1092"
    sha256 cellar: :any_skip_relocation, ventura:       "32e73063a0bc68ff27ca00ac8a78f3a255f5804a0c5498a05ba4c794c725dc4d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3df3a0eb2e0f7111d5e47217c2b067f6d2ea8dd269eabba4e99febd085230ebb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7579e14d692b33862002817ac90fb53e264bed31788008ba473028d3d93ec1a6"
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

    bash_completion.install "completionschezmoi-completion.bash" => "chezmoi"
    fish_completion.install "completionschezmoi.fish"
    zsh_completion.install "completionschezmoi.zsh" => "_chezmoi"
  end

  test do
    # test version to ensure that version number is embedded in binary
    assert_match(commit [0-9a-f]{40}, shell_output("#{bin}chezmoi --version"))
    assert_match "version v#{version}", shell_output("#{bin}chezmoi --version")
    assert_match "built by #{tap.user}", shell_output("#{bin}chezmoi --version")

    system bin"chezmoi", "init"
    assert_path_exists testpath".localsharechezmoi"
  end
end