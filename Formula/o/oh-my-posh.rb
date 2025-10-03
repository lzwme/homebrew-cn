class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghfast.top/https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v26.26.3.tar.gz"
  sha256 "e3e3c8761e724d5baf393f8e47ab211c0bcff4ef288e24cfafe881d152371bd8"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "140276871ff6a01ee2b5ae56b6f42d666be5ffdbe6e1a1e37c502d2412b1dcbb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "84fae3a227aa4072bb421c4ce7b980e5e1a9ae607544c11ccdab17aba997f766"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0884175e8365ae76ff48fa3fb30371714befff6e704d702784989c47c67b34dc"
    sha256 cellar: :any_skip_relocation, sonoma:        "0512c4b3cc9b421a867610d337804d29e8366ecbc522913619ce791a73d0a4f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "deefe4513afebf9040e7853026e762ed893bdac226c044bc1a23ae4c3b9dd19b"
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