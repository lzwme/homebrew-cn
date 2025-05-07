class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https:chezmoi.io"
  url "https:github.comtwpaynechezmoireleasesdownloadv2.62.3chezmoi-2.62.3.tar.gz"
  sha256 "4d4b0b5348191971fcf82fc4d9aeca1ea2263d06b430f3bdb213bc7e19a4040e"
  license "MIT"
  head "https:github.comtwpaynechezmoi.git", branch: "master"

  # Upstream uses GitHub releases to indicate that a version is released,
  # so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3b1bb0f75c688e743829b914e1b188c68f963bece78a64a0aaf7c0def6b2fd15"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e7705f741fd2981486afb259473efc960beb2bb6c7b922b34874caa731b76852"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0b865276f94f0f6a13547f719b46301b54b802893890ed623239c2eb96324193"
    sha256 cellar: :any_skip_relocation, sonoma:        "3cdc52b1250371424fdd5f6ee8f047a57ed1ed89364c0a8ff7ff2495e1d3e484"
    sha256 cellar: :any_skip_relocation, ventura:       "b74289ef7c9b3ebc342f24ed7be7e044a0098eebab8f0d3b205b99769eda6804"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "212ff9aa643c01f35d71e4bbd34aea44e50adfafb0149a7c7c47dad0a103644f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe72758d274a82991ef5a0b872eb069afcaf2d90fa546e2b0fe9a411022dfffc"
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