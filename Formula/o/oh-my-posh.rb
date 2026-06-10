class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghfast.top/https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v29.15.0.tar.gz"
  sha256 "261a549c161ddc04b3c22592e5f02f676ead26ea5d134ec1ee4fad287b9b7a7d"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a9b094120bb516f230bdbe724c21411815b86f4fc0441a91bd1df7c543b3d0d3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ad1cb8d94c7f534622a190e73cc0995f7b8ab26e6a18e960a6f26ee229710fc2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "779ecc5197a7d9520c13b0d1d6073f042574a30ac3c726af30c2c6fc0f313b76"
    sha256 cellar: :any_skip_relocation, sonoma:        "5b0f3531364a104d170fbb9659e80a65b9cb27b60c6420307219e747455298ae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d070a5e011fd99f211bc5daa0f0178d510bcaa8bdbfbf11b49505266e2113a7c"
    sha256 cellar: :any,                 x86_64_linux:  "3389e3be4681016bf880c84dc18b3b38b5589c3c66be9c217c852b18f98fa2c1"
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