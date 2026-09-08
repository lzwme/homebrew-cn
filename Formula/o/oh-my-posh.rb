class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghfast.top/https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v31.2.0.tar.gz"
  sha256 "bca38f2cb1643224042c32310f851c907d60b05af6167b87cd52f890a554530b"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c8e1ecd4f74a8fd1b58ef82ab20d7689ab3322616d6965d5a2fb4de6fa595e39"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "02b0efce07e0710434f9d83fe1c576bc471f743773048cd39b6f9e11f6ce8874"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9b11d51eb20d45b8fcb0d5bfd71c527aa4386e3c9091077293e46ef47b6b97c1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5c161ba906675e41c4ae59700f286ad493ea81624c33228db6caffc8f205db47"
    sha256 cellar: :any,                 x86_64_linux:  "9ce14dabfbb25973207f6b7ae9bff2425430c66718439073f8a2a25939867999"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
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