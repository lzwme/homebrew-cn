class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghfast.top/https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v27.5.2.tar.gz"
  sha256 "a31741b4445986ac4ee831de023e89e14a326e24c07af6e3d9fa9c61d39971c2"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6404b3a01a8392c7c71b429d23543963d245d4f1a185e69cce5f72b4162c29a8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c75ba514218055402361a03d2159145749fb1e302d7e723afe2914708f52cbdd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2a0ac1ac71dfa4d83424043fede30cb3b1beb8f2763554a0aa1bb03afe26467d"
    sha256 cellar: :any_skip_relocation, sonoma:        "cf25cc6c3c2b6520620d9e29a3876ed277e368458fec6ff19c72124161c4efa2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dcd542831517bc306f624282f0fdeb3407ad63a4e4c02a9e8929a16e7fc4bc15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d59acab09e4fb783871eab74cb07400db32367daf5379442d0802cdec13460fb"
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