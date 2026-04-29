class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghfast.top/https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v29.11.0.tar.gz"
  sha256 "5272bea8451b5992ba61a1c5c284bb2cdfd541d7bbd6881b430c6aa7e59a1bd8"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4081c584da22540013182b31fd723b8059483ed9ea3b9a3a419d0a588cb9c656"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c7050dfa13be5049287ffeb95030091796d83dfa70ecffd7957640536c8a6cc8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "159b151a8d21a1d753841df4fd36c6945bd175242bc218dbda032a65c554199a"
    sha256 cellar: :any_skip_relocation, sonoma:        "5702331a3bdad5fd559966ad834824bb4e07b52751a98c60e9db6c513b42a124"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3468279a716d9afdc72f3067eef633de07817afcc2c5044d5285bd6e512c202d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d65cfb593fe188140f9545dfe532ee596d15ab3aed8f65cb8826da88d8250680"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Version=#{version}
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Date=#{time.iso8601}
    ]

    cd "src" do
      system "go", "build", *std_go_args(ldflags:)
    end

    prefix.install "themes"
    pkgshare.install_symlink prefix/"themes"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oh-my-posh version")
    output = shell_output("#{bin}/oh-my-posh init bash")
    assert_match(%r{.cache/oh-my-posh/init\.\d+\.sh}, output)
  end
end