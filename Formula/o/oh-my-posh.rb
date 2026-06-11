class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghfast.top/https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v29.15.1.tar.gz"
  sha256 "45f8b786c3c77fd6ba5927030f04f91e906eef708c23025d50f78e2652e3cf26"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2218f31d139697cd3be84044be05c7106c38dc33b21c6a27ceb96b702ab8a2c9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cf913a18ea1eb6fdf857a264771ecfe72a5c8da8bdf94ffa99236b5c51de40a2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1f264b7fb5fb5b01754e01902e6c098a420a67961f725fcf2ca2f942ad940962"
    sha256 cellar: :any_skip_relocation, sonoma:        "c7bac7025ef1ef0fa4c640f3e8a2db94d07119a53670ffa708f5b9205dbd6378"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d11541d7842331b11c422d46221a7c67a8a9a608cb0cb08eaad8f763726f1e1d"
    sha256 cellar: :any,                 x86_64_linux:  "62b7df760d684ad103766c0c780bbf6ea8f1b027934fee62d9528d57076a965a"
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