class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghfast.top/https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v26.26.0.tar.gz"
  sha256 "c637b8dacb047cefc6777a207981bbe40898911c7114bd3cb8e00447bf414abe"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "16a29fdf13bc9e7a040dbd6e34c93c3e4f04ebe5de6d0fcf0f3b12579479ff70"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2d1b9f250c079ab2f4ec0fc3c68deabd1009225673cc821eac56154fb905234a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6fdb08f3a6a0af1b000e34ae1fd9db2e581a7f9c7f150908f8f18ace54144b30"
    sha256 cellar: :any_skip_relocation, sonoma:        "cc94765a424d1ef8dc74bae64855151ffda1cfe8bedc156ad029f6a20719a80f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "37d4c01cb2b811cfefb2ec53d7eb93cc1276cc6f2fb39d2635301076de29ddff"
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