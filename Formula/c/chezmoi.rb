class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https:chezmoi.io"
  url "https:github.comtwpaynechezmoi.git",
      tag:      "v2.47.3",
      revision: "4f76edb5295068569d7c6311020ac0094c77ef44"
  license "MIT"
  head "https:github.comtwpaynechezmoi.git", branch: "master"

  # Upstream uses GitHub releases to indicate that a version is released,
  # so the `GithubLatest` strategy is necessary.

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "860dac809693e65de382888085ecaf73c4cdf10fff6e9f340cc1c2f5467a72b8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "144ae84d6246eadad825311fdd8d35461cdcb86b098ef602b7aae7c7e362a894"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1f26f450a49b1043aec2232f765c3ccf01d6cd26fce5611052c961677070cb43"
    sha256 cellar: :any_skip_relocation, sonoma:         "cb4329bfc53d7d393ef4f4e7160eb1442489de5fcbcc4965f30adc2d28234c1d"
    sha256 cellar: :any_skip_relocation, ventura:        "04012d2dbd749ba216a2f5cc05de4d689e4a98f26833cbf9c516454126202299"
    sha256 cellar: :any_skip_relocation, monterey:       "9b1bd74a2886590c30bf6953a3263e9721d3b8751a9a9424eef6c19e18c71794"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c702f2630de69abc25e6dc2d4ab7ac43b4fe73750cbef50a86524ec3c472ec6d"
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