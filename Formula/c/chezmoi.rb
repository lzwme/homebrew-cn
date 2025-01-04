class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https:chezmoi.io"
  url "https:github.comtwpaynechezmoiarchiverefstagsv2.57.0.tar.gz"
  sha256 "123efcfb37de7803ccb9ddf666adb3c7880a62c62550b877fc8f928e1622b4a5"
  license "MIT"
  head "https:github.comtwpaynechezmoi.git", branch: "master"

  # Upstream uses GitHub releases to indicate that a version is released,
  # so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "77ec7d2734d23bf0d9934d6d4744d8f19b1823cb98b79f8d55672b5a1f967df8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6ecc493e76cce0753b19ece6210f8e5afbbca482f36aa44777d29e0d8b9f8424"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6950d012926f1f58b81ef15778632d6ee82fc243a0720e85c5391035ecb7b192"
    sha256 cellar: :any_skip_relocation, sonoma:        "5a8f970f1b158df239406918466394993a8eef00eaad46d2bc9179818300ad15"
    sha256 cellar: :any_skip_relocation, ventura:       "0ff44c5283c43dc1114c0308b010507a697d21dfd4815c968603817b6cf98d4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "48ca4c1c3f1a96365acc71402e6e3de922830aa635e859a04158cf6f9a1bb2c3"
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

    bash_completion.install "completionschezmoi-completion.bash" => "chezmoi"
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