class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https:chezmoi.io"
  url "https:github.comtwpaynechezmoiarchiverefstagsv2.57.0.tar.gz"
  sha256 "123efcfb37de7803ccb9ddf666adb3c7880a62c62550b877fc8f928e1622b4a5"
  license "MIT"
  head "https:github.comtwpaynechezmoi.git", branch: "master"

  # Upstream uses GitHub releases to indicate that a version is released,
  # so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c0fac66a51b0519719cd49aa5543621d8d11e2eb5a56d084895585b5bdac1379"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "54b92c851ded9c1b72b0daa316548915ac4197b53105798ead1708fb6f12171f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cb4ba0e8448aa4aa1c8a87b77a0753af617a6401ff0722f4023057211c70c86d"
    sha256 cellar: :any_skip_relocation, sonoma:        "c5c47bbd2cc1486b3e7619a4319a491f123095cc6774cd382a49db3ea11211ab"
    sha256 cellar: :any_skip_relocation, ventura:       "38926492b3d0de4fddbeabd7bc2d1ec226007252acb3673cdbdc78b8573bdb91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "78f18930e2bfc5d0cb3c17f456e1d4bfe8509e36f3f57a2b70265e5a40cd40da"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.date=#{time.iso8601}
      -X main.builtBy=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:)

    bash_completion.install "completionschezmoi-completion.bash"
    fish_completion.install "completionschezmoi.fish"
    zsh_completion.install "completionschezmoi.zsh" => "_chezmoi"
  end

  test do
    # test version to ensure that version number is embedded in binary
    assert_match "version v#{version}", shell_output("#{bin}chezmoi --version")
    assert_match "built by #{tap.user}", shell_output("#{bin}chezmoi --version")

    system bin"chezmoi", "init"
    assert_predicate testpath".localsharechezmoi", :exist?
  end
end