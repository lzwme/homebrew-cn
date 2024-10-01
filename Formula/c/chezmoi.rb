class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https:chezmoi.io"
  url "https:github.comtwpaynechezmoiarchiverefstagsv2.52.3.tar.gz"
  sha256 "a3986d25ad831de00d5a0937062a413af72aaa2c15d515abd02cf82d79d813c9"
  license "MIT"
  head "https:github.comtwpaynechezmoi.git", branch: "master"

  # Upstream uses GitHub releases to indicate that a version is released,
  # so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "592372b942600b0556598ca5b701e707a0ce31514fea8014a519007a992026cc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f386a1f8948b0ef31878668c02da92d7abac748104f7ee45daf3345f3ed0a373"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "05fc5d2e8ab63dd022a8355785899b44b3860a4a5ddd7c31266ef43e80d6e8a1"
    sha256 cellar: :any_skip_relocation, sonoma:        "2e2889669b8bf72a40028b22d0e23124c6b3ffa8ad0ba3f591bb672d9701a60b"
    sha256 cellar: :any_skip_relocation, ventura:       "6cf08461f6a5a50b9d181e1af2c8c3e52957fb81eaa98244429df205f5b44fd1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0f0e00b6d360f4a648d68bc7640663a4feb253b7935e2a9da882e26e9938acd2"
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