class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghfast.top/https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v29.28.0.tar.gz"
  sha256 "2fc263e93a51f40d2e8defb85b9d610866f54eb2ee547724bff0c8c70f9182ac"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d0598d2d22325203669eb867cd5d4cc28b717478506ef6a3378163bd0ccd2089"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a98fffa4a2c8692a45f5f2c175740afe5746ef4294f605ed0118a7412d4bdc0f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "147fb08e415a5d9d3465792d06a0f24be213bb209ffa46d44e48cd9b51ca48ae"
    sha256 cellar: :any_skip_relocation, sonoma:        "7c83ba17c64cfcf0048c2f51dbcc8d0a7caa19888a112e1e9bd18ae263b4a22c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "587a79e7e2bc986ca9a4ad54d739d9031ca2d752c074d8a0253f5b6fd114d67b"
    sha256 cellar: :any,                 x86_64_linux:  "4a693d6e2fb22996f3345dd8a7a8f2d01244f9eb7f6836e4662e3c9eb2373eb9"
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