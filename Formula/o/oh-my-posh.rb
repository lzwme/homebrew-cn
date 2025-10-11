class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghfast.top/https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v27.1.2.tar.gz"
  sha256 "8555aa3af1d0efa5e8510774f8d51580247349c0efd595cf4045a218543a148e"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "576ce4c562580a4cf03b7379465312b49a232f0126df6bae43db560d5e2163fa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ba0ac9479ad1af531f3cca426881c6269e3e680d9dd5acc7caea282eb19d7583"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a81a416007ca9de3c8377bf4109f966c5c7e446e029540dc5e6419cc6cdcac5b"
    sha256 cellar: :any_skip_relocation, sonoma:        "a6019c5c1c91685f19502632f6776ac6a53f9d41db7b051f15ebecfed03610be"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "75ea91d669072e0010791946419750382120b0d5ed4c9a78c1665bc038f73539"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "171cf86419b4e5ae97ab82b5656078972d8fb0d39e4d2ca3c754e486d2dca366"
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