class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https:chezmoi.io"
  url "https:github.comtwpaynechezmoiarchiverefstagsv2.56.0.tar.gz"
  sha256 "bc56294a3c47c0dfa5e22f05b1e8f6f656b650fd212d83975039a521b74e3d3c"
  license "MIT"
  head "https:github.comtwpaynechezmoi.git", branch: "master"

  # Upstream uses GitHub releases to indicate that a version is released,
  # so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "59981bbb51876426e0f5dbe45fd7941dc817e74626b8727bede5094ca2f11095"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d57430e5ccfdc7362398e638eefaedd2645e6dbc356245daf5712c76f3de0a4c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7dc2f6fbd8f6649608760cbaab11c3f3c185425498bf1aa42365dac0806eb854"
    sha256 cellar: :any_skip_relocation, sonoma:        "ff5981b1bab8536e7b2fd900cd2469fa0ef88d864ee8664c68bf8290ce7705d6"
    sha256 cellar: :any_skip_relocation, ventura:       "357f2b6e81ebf953a355a4696d4899a1cc92a41169afcb03bcd441e3bd502867"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b7d4b1be25655a3a283277296023b21680f81037e4a87e2ee2e393c3b26948b2"
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