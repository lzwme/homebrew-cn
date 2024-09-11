class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https:chezmoi.io"
  url "https:github.comtwpaynechezmoiarchiverefstagsv2.52.2.tar.gz"
  sha256 "0bfe878d901f5e171cfcab7bd4d647f3fbf7f882be9bf747fabe188a9815e91c"
  license "MIT"
  head "https:github.comtwpaynechezmoi.git", branch: "master"

  # Upstream uses GitHub releases to indicate that a version is released,
  # so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "61f1a960c680d7327354f69054680659e19acc06863377027fb2800a68c08dde"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "14493094a641f6f0d634482a531a8e5255456fac0cb1b87c989d8eded12126f2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3cf4fa651239e063794d1397bd536db648ca9132605812605c81ea36fb277fdd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6de190f9a8598772d965c3adbac8225e905813937d0d0764fa89fa0fc035fc81"
    sha256 cellar: :any_skip_relocation, sonoma:         "07f6c47553f633b4ba0d6ec4dd2d1f0823603fedf5650311c2195f692e2b0cc9"
    sha256 cellar: :any_skip_relocation, ventura:        "83dfa686eedd4effc0c4251fac354c14733ae73783c5bec6047e84a05381c9dd"
    sha256 cellar: :any_skip_relocation, monterey:       "86c01816b9d65b55b0dd33f0cba9ae7f4f9e33f3867e01ddaabcaaedc5683489"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cc4aab0b28f20122bdf9ed57881afe417cd8721fb3ce718104e777797ac8baaf"
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