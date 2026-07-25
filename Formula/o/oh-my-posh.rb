class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghfast.top/https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v29.36.0.tar.gz"
  sha256 "24c26c1819a4ee0a914bc5db1b42c86da569dc1cfa44c2bb5eb247870e47662c"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4b6abba82e86ab0433f436a1148160fda37189439132d38e487ec0500c5603d6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "67bbbf0f7a58a9b12e00855746d82a77a9af7e622f60966042073eb766f093ad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d0d02f96412ada3f1ebc7a1c158006b49c48ec9226c4e5ba6336f3e42d92ef38"
    sha256 cellar: :any_skip_relocation, sonoma:        "08cb48c177fc66d456205137045af87699991fe7034a44195c9bc150c643ae16"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "be4497aa8e6aba4c73881a54254fd480ecf5ed726c880046915f26667d3efa09"
    sha256 cellar: :any,                 x86_64_linux:  "070bf0e8c3a6d58255855ff29454e7c5b8f46c3ad9bb0d4aab63f96748227d52"
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