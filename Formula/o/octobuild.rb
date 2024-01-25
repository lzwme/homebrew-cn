class Octobuild < Formula
  desc "Compiler cache for Unreal Engine"
  homepage "https:github.comoctobuildoctobuild"
  url "https:github.comoctobuildoctobuildarchiverefstags1.0.0.tar.gz"
  sha256 "5d159ffd1e2f24cca8f521f489687de4ce529ada58f0107a54d14e34f0321b7b"
  license "MIT"
  head "https:github.comoctobuildoctobuild.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "47c87fc955b68ff1d8fea670a87953ffa150d186ec63366d60cab48a1c3796a2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "98370d3d6e55f5a9b9f9558ae724ddb3196114c65f0d8102d536f49ccd1693a0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c79b23a251212910e01110626dee38b61fb4edd15885a00694475f8def99a6fe"
    sha256 cellar: :any_skip_relocation, sonoma:         "fbee071d7c276b6066fb2abd2d3e17885df346c43a9444146604815678b1dd6b"
    sha256 cellar: :any_skip_relocation, ventura:        "e683dc462437297b06eb5e91130d34224d2c2a59ba15ab8dbe84504cb86d818b"
    sha256 cellar: :any_skip_relocation, monterey:       "14dbcd805e70663d1987f761d4bb66dae18c89b3dcfc91431896155812ff2f21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b4906a42b59706dafced976c8d681ffc86e7572f5bc7db8e805585a13d9bf71c"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output bin"xgConsole"
    assert_match "Current configuration", output
    assert_match "cache_limit_mb", output
  end
end