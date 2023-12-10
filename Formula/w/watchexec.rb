class Watchexec < Formula
  desc "Execute commands when watched files change"
  homepage "https://github.com/watchexec/watchexec"
  url "https://ghproxy.com/https://github.com/watchexec/watchexec/archive/refs/tags/v1.24.0.tar.gz"
  sha256 "ab010c66656bc123068c824f3b0c5350835a68e6721e3ad7173f6068412ce87d"
  license "Apache-2.0"
  head "https://github.com/watchexec/watchexec.git", branch: "main"

  livecheck do
    url :stable
    regex(/^(?:cli[._-])?v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "46ae3a875239a0792811d0fd2e0f6d0cacbcb390b31580d7a3dcefffbbdbef27"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b7f082edb420f38e8588231e8e90e18a187d8ee6b01ad501e99a7e5150937310"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7155e231c6ed7b49013858c7790bd006215a54d2be6e64dc7676f4dd7c8ae9d1"
    sha256 cellar: :any_skip_relocation, sonoma:         "fb9bec6b85acbe064d5834ee1d8f7fea7d4759a296d37c930491fe6987c8178e"
    sha256 cellar: :any_skip_relocation, ventura:        "f328ec9123d075f1a84ffa0320a33d8a2bc6971ab88e45609cc8413147e4c6dd"
    sha256 cellar: :any_skip_relocation, monterey:       "7b65c7fdf595d66aeaf813c3b5464c9caabce4d1ad5bee61b0a6569ffd679c56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b10578458d55df00c72d62e70a70403fbcb243c2b7602b494120e26db5b15999"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")
    man1.install "doc/watchexec.1"
  end

  test do
    o = IO.popen("#{bin}/watchexec -1 --postpone -- echo 'saw file change'")
    sleep 15
    touch "test"
    sleep 15
    Process.kill("TERM", o.pid)
    assert_match "saw file change", o.read
  end
end