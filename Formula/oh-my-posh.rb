class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghproxy.com/https://github.com/JanDeDobbeleer/oh-my-posh/archive/v17.9.0.tar.gz"
  sha256 "d6279d69f937b54fe0bd2e9d76a71c1e3169c7731cb43e487642dcbc2c2403f9"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "37291748d010ee948fafd72b616de0fbf51e6bf8f3964d6a60babc0e43f2b413"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8d621fa172b48f8accb24a4f62a1cb85938838923bd8b7234eafc3da772a37eb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b90567feccff46111c2253af1cf553ae9df735d357ae200f8d1fa8ab92c0bbdd"
    sha256 cellar: :any_skip_relocation, ventura:        "39ad88b7d6079d91799bd87bf0b9f6d4626d7ca75fb2a87ec4a106d067b39e15"
    sha256 cellar: :any_skip_relocation, monterey:       "350f5761ab35bcaf25d19a1e613bdb633f38cf74dd5ce341be985c6dd74b821d"
    sha256 cellar: :any_skip_relocation, big_sur:        "eed2f776e23138e0310a50b2165fc207fa59cabc27b5b3396ef4d20c951d877c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d954477eb1d9dcc733ee489aafa75914db9a9839655bfbe209793915d54f2fd9"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Version=#{version}
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Date=#{time.iso8601}
    ]
    cd "src" do
      system "go", "build", *std_go_args(ldflags: ldflags)
    end

    prefix.install "themes"
    pkgshare.install_symlink prefix/"themes"
  end

  test do
    assert_match "oh-my-posh", shell_output("#{bin}/oh-my-posh --init --shell bash")
    assert_match version.to_s, shell_output("#{bin}/oh-my-posh --version")
  end
end