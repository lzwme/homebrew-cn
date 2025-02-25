class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https:chezmoi.io"
  url "https:github.comtwpaynechezmoiarchiverefstagsv2.60.0.tar.gz"
  sha256 "70a077c9be09fc3f7dd684ab9f80c85f60702fea881789b7fb1b9b9b08bce275"
  license "MIT"
  head "https:github.comtwpaynechezmoi.git", branch: "master"

  # Upstream uses GitHub releases to indicate that a version is released,
  # so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "39f9236df39188a2b715ce92e60a16e808ae864e516b2cfccd0ed9b35590c140"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "511f88b691dd1dcf1cfe77fd779e14929fe7c0fc3490b3c8ba50cf8c59bbe279"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cbe044178fd44c5f42901eb2cb9ea3b67c8918c9d4690fed535dd74e0a77a82d"
    sha256 cellar: :any_skip_relocation, sonoma:        "b72d14d9b46ad7896a97ca2cf978e598f9ace0f03adf3c836fca999c2851ed15"
    sha256 cellar: :any_skip_relocation, ventura:       "9a1668dc6ba57d751c6492c6bdc704378c037ff8b07bfa3f1d7c79225149442a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e75629237f891c16023071ecfa8789a39ca5325db8404c18852f55f25e056b7"
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

    bash_completion.install "completionschezmoi-completion.bash" => "chezmoi"
    fish_completion.install "completionschezmoi.fish"
    zsh_completion.install "completionschezmoi.zsh" => "_chezmoi"
  end

  test do
    # test version to ensure that version number is embedded in binary
    assert_match "version v#{version}", shell_output("#{bin}chezmoi --version")
    assert_match "built by #{tap.user}", shell_output("#{bin}chezmoi --version")

    system bin"chezmoi", "init"
    assert_path_exists testpath".localsharechezmoi"
  end
end