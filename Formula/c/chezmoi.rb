class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https:chezmoi.io"
  url "https:github.comtwpaynechezmoiarchiverefstagsv2.55.0.tar.gz"
  sha256 "1fa36ce5ffff5a49e5a69c0910b866086749f359ae7afa06cbcc17b3bc9d8ca0"
  license "MIT"
  head "https:github.comtwpaynechezmoi.git", branch: "master"

  # Upstream uses GitHub releases to indicate that a version is released,
  # so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bc5fb89e6dcdaadcf2fe291ef22edeb46e5bd6b9ced70b6129ec3feb9a45d864"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e5cc6447afb83e222093eb3e3d081f86138343b9cabbc65f3f22b4c92101aadf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8610e7455c0d013c7addc42dea780baeed9161662d2ddb3d108866b979605073"
    sha256 cellar: :any_skip_relocation, sonoma:        "e0a19c50c7d45c389dbc13886e84aab6b285911b0b59fa967335af1c47a6a5cc"
    sha256 cellar: :any_skip_relocation, ventura:       "9bffc3562eabb001ab9bae4771e8c3378ed6cf8060a4db7f12883c23d653d7b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "72cef43ba9bd5c409de6e703215150948c7a82be799eaf578bc7e536d6dc9552"
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