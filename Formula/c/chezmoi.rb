class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https:chezmoi.io"
  url "https:github.comtwpaynechezmoi.git",
      tag:      "v2.45.0",
      revision: "371703e93f0c54dad81f7cfbea2906ece15a7428"
  license "MIT"
  head "https:github.comtwpaynechezmoi.git", branch: "master"

  # Upstream uses GitHub releases to indicate that a version is released,
  # so the `GithubLatest` strategy is necessary.

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2e9878630b34ebfc0a0957c0df9ab86aa871e088f3c316896c8b55c936327d65"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0423ca86ced1ad5d43a9b8b97692f35968d86b602c146dbdc28e13a4711bfd38"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8d29587a622f3ae840b5114e88b76a04472354b57b21612209996baeb9521a57"
    sha256 cellar: :any_skip_relocation, sonoma:         "151de8a516bc690a47b1d488e6ee59b58ee6a726e8e775cd7ac25e92e01e620b"
    sha256 cellar: :any_skip_relocation, ventura:        "0a95c6feb9ddafc27d76c1ff0fd2d9aa7ff56e0ebb698230531ab4f53e2d9c3f"
    sha256 cellar: :any_skip_relocation, monterey:       "99cce4259e52f56b9d312d58252443cf1e35d2f3115d43433a73bd7412ba8df7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7e6233de89a6ba706737ad7b9a22392aa2fb99090d9a0b7001125fd0f955b44c"
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