class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghfast.top/https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v26.16.0.tar.gz"
  sha256 "6016c29b4bf02ca2dcca8eccb13e8039949c1ee040e5ad452cdca8d51be22aee"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dd72d5ec0a2677390fa9e8b79cd11d28f2d33e3884d1f2228366481e3d87955f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8429a6de2505bc089578f83a023524ec2688885b7acd7188ebacf3d43e1dff05"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8fdffd29d77e13bb947227bdc8cce05570c393c45e584cf37952b530dd613a0c"
    sha256 cellar: :any_skip_relocation, sonoma:        "dd478e26853ca3260fa6229caa9d716c9156844d5a1f458d3192d248f0033467"
    sha256 cellar: :any_skip_relocation, ventura:       "b35c1754c2cce5bdb0f7c68b348d11dafb49b9ffa06bdcd7713bdeb0a6712ee1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "51f312d8bfbf0dabf083ef87a053d274fd8ca0704bd6ca77c3b006a7327007b3"
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
    assert_match(%r{.cache/oh-my-posh/init\.#{version}\.default\.\d+\.sh}, output)
  end
end