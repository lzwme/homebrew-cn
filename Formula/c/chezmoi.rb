class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https:chezmoi.io"
  url "https:github.comtwpaynechezmoiarchiverefstagsv2.54.0.tar.gz"
  sha256 "74281a5b1d9b4e8b5d6f4775204d5b56500649b5d906944a29f6c284aa54423e"
  license "MIT"
  head "https:github.comtwpaynechezmoi.git", branch: "master"

  # Upstream uses GitHub releases to indicate that a version is released,
  # so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3d4a159343528c7c35b09526b9e63d24c72afc45fe5ea24c5cb2a2ae4c7ca722"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "06786821b33f8d5a5ebe0349f48e722e7ecbd4d4ffe7af7d73c55e44e18e6722"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f4ee8dd7abd1afc406487cde5e91d280ef87aabdc9e7742bccb2e41c573fb429"
    sha256 cellar: :any_skip_relocation, sonoma:        "7fa58592832762fb0d6d6f3b8d5f5d767185d8ffea5a39f5384b7ef1b12a4c03"
    sha256 cellar: :any_skip_relocation, ventura:       "4d7ab3b96fabc3c1103db3f11ee164e75cd0b12cf47fdc935a00bc6b2c88b313"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2dad93a0a65df602176b05e17e89e7ec550fb28b5cfb79c8ce9da8591fcefda0"
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