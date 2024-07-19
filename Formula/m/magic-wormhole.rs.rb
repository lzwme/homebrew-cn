class MagicWormholeRs < Formula
  desc "Rust implementation of Magic Wormhole, with new features and enhancements"
  homepage "https:github.commagic-wormholemagic-wormhole.rs"
  url "https:github.commagic-wormholemagic-wormhole.rsarchiverefstags0.7.0.tar.gz"
  sha256 "dee1f6784310c0855473aed5fa45866b74e90baf3807e881dee8139caf20c9b3"
  license "EUPL-1.2"
  head "https:github.commagic-wormholemagic-wormhole.rs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a69c7e6833c59df6da5a9529737823aedaff273802b7f461b624a6dd6dffb11c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7b30394c767a8eef7cfdddd48f53cd896bb4cf5cf5f9604a4a6aa4cb56742f78"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d4ce2ac8fbbe62f82e8078d2cb29af22861bc7c0cf554a83c2bf4906afb1cd00"
    sha256 cellar: :any_skip_relocation, sonoma:         "24175fe4e1a585f986850e0f890b0c0512f829ef297e556e28f871afd6510849"
    sha256 cellar: :any_skip_relocation, ventura:        "10d418a2b9bd389896c47ba20f3acf8f69960994535fc79a6440ce7a7ae4c572"
    sha256 cellar: :any_skip_relocation, monterey:       "15143940a55920f228cbf93305274273054b191381436f40d72d01c038100b04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc4b3ebc907ac2ca40b0000f593b744d317f759401fed67b8138a964b5880d48"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
  end

  test do
    n = rand(1e6)
    pid = fork do
      exec bin"wormhole-rs", "send", "--code=#{n}-homebrew-test", test_fixtures("test.svg")
    end
    sleep 1
    begin
      received = "received.svg"
      exec bin"wormhole-rs", "receive", "--noconfirm", "#{n}-homebrew-test"
      assert_predicate testpathreceived, :exist?
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end