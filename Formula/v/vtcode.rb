class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://github.com/vinhnx/vtcode"
  url "https://static.crates.io/crates/vtcode/vtcode-0.58.24.crate"
  sha256 "b163b1020ec080ba272c41c2552e2eb9ba404540e2cabe429e388574f166b2f4"
  license "MIT"
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bf1e4c201ca968683d6ba2149d4db9176576dbcda45f90d421b3598e80595b03"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a37d9c5f4892a981f249246487d2fd947b0805c3540081140f07961dc1511c74"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "934f3ebd4361ed8aeb0e7ab8b2170d83c0457a7d7d5f1a157a22794b509070db"
    sha256 cellar: :any_skip_relocation, sonoma:        "2cd85737eff911685950cbcc16afcf386a59104aa9838e70a984d71f75a9d8cf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5ee1fa788d99a90c992340f5c8b571f37cd8b7d7dbbbc67e92ccd4655139bf4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b4dea8bcec9e3fb5d8ec139f2919fe7677ddc244af690c8add469dc4e92f986"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "zlib"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vtcode --version")

    output = shell_output("#{bin}/vtcode init 2>&1", 1)
    assert_match "No API key found for OpenAI provider", output
  end
end