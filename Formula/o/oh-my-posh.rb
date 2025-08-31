class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghfast.top/https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v26.20.1.tar.gz"
  sha256 "d7bf83ba76271f963ef2ad10db0d734e77533754e82c554c8e9e7fac961bf588"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f16f1f3c46b4a2a9e48f3564b7e98a1ba2e9e0662f7d15b5c15177a03e4f815c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2cb9f9e08afdd0d1b89ce5d7096bae5edd6b272d92dc1e389548fe17a0dc4067"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6e94f123c02e12a97d007b4478ab2490bc99bc860288754716a5bbcfe6e6908e"
    sha256 cellar: :any_skip_relocation, sonoma:        "6f6854e7310f64360214dd3a50221c44e05033375acc1165e16f280a83e8eb0f"
    sha256 cellar: :any_skip_relocation, ventura:       "19cb553cb0cb0e14d98d40c3d175175d66e23c8b988f627d53520fc0619a0e11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9730a621fd4236d033bab1a700d264d1b56d9a213fa108ce01fa14f35067a836"
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