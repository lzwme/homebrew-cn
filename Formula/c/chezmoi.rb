class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https:chezmoi.io"
  url "https:github.comtwpaynechezmoiarchiverefstagsv2.53.1.tar.gz"
  sha256 "b90d70d545c8591e4e3df73aa5d3092ecf04ecb8d8ff6f05493400bd3fceaacf"
  license "MIT"
  head "https:github.comtwpaynechezmoi.git", branch: "master"

  # Upstream uses GitHub releases to indicate that a version is released,
  # so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1916193bdfacf4c6ef51662c60774ddfba6386aa7141deb2906f7ce11ef422dc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "da75394e86a4d9758adf47e148a1617d02a31dab6136b277d68a7b81e2a55998"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "083acf304f9c84364f17bd157e5224347991e52c85d72db512b0d7588d8f24ca"
    sha256 cellar: :any_skip_relocation, sonoma:        "f07e0c8adfcde3c6c20ac9c9bf40fa395be8605fe53797a6f14a59aed665151d"
    sha256 cellar: :any_skip_relocation, ventura:       "4c591b7351bdd54b428ee0cf03dca6bb204564d2ab2095c69e06b2c37d6801fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "16fd5ded9858e2abffc24f9960c06fd87be20f2e409f8707024c4d7f4b838352"
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