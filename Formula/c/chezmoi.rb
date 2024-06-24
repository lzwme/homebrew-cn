class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https:chezmoi.io"
  url "https:github.comtwpaynechezmoiarchiverefstagsv2.49.1.tar.gz"
  sha256 "898ef09b52bd23619327f4bebc83d58b578c5e5af9310a9ce12b556bb4c3cbc0"
  license "MIT"
  head "https:github.comtwpaynechezmoi.git", branch: "master"

  # Upstream uses GitHub releases to indicate that a version is released,
  # so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "87c4d911b03d25b5fa6c0fe2146b222cd15745fa4b93be23eed7dd97f2ad9af4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5ad1f3d0620f3b50e16115e75cd84d79007ed229c4300e078ea0fc0fdcaf150a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "666983c16c02c14de222367781e4137afbd144b7fd3db54e8e34e1f4371a326c"
    sha256 cellar: :any_skip_relocation, sonoma:         "5c0b2832870dc8bf7ecd25887e23fa30133f5dc0cd4b105e5900a7e937cc26a9"
    sha256 cellar: :any_skip_relocation, ventura:        "b3d35d024fdc9bbca7cedd1e7a3ba9cd3fe52f7ff210d38ad2380a5e554700eb"
    sha256 cellar: :any_skip_relocation, monterey:       "9e5b0e916965e5dbf437b419e623ecf65e3776550257b591bd2538e5893717fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dcc47a8f28772af397990099fb96946dfb8b07063929166983465c1ae4cb0d45"
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