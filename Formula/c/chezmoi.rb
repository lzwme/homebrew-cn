class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https:chezmoi.io"
  url "https:github.comtwpaynechezmoiarchiverefstagsv2.50.0.tar.gz"
  sha256 "20529464eba8b6e2a801bd6898c75fae4ce0a4da7aadb873241a0ea461c18454"
  license "MIT"
  head "https:github.comtwpaynechezmoi.git", branch: "master"

  # Upstream uses GitHub releases to indicate that a version is released,
  # so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "43ba223b72e45d30f0106cacfc1a621120e9fd7544f3bef86b78848a9d84b504"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f46c335e34a08259cb4d00875e37041accc64b1a7e921624e1608c8382d44094"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4e7159a78a19412a883abb12e5256c57deea01db7396d45748f178b0c39d9658"
    sha256 cellar: :any_skip_relocation, sonoma:         "9011e73da790fdddf668fa9fbe193c1638b7f2a5e7c2c2ede35bdc5a769b6063"
    sha256 cellar: :any_skip_relocation, ventura:        "98bc55f25c3e293db8a45799d7a504f00a3633234291abef67d3272b0b2a1171"
    sha256 cellar: :any_skip_relocation, monterey:       "5abd0724b1881956c22cb7558bccb19a9d4eb8d0c376489d7a21b49be79eee93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa7ecab44fbf8c44e88729a4b1bb5a27cfc71d61d9bbde9fa5e83504c78654c5"
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