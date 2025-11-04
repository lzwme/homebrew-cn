class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://github.com/vinhnx/vtcode"
  url "https://static.crates.io/crates/vtcode/vtcode-0.39.13.crate"
  sha256 "93d1894ccd74cdef313ae2c52b1e0be102b0a5c1335645b59ee69225469e787a"
  license "MIT"
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "53319b5b26171718d551f89fc256c4871121d0771d884febffd6fbbc4288f017"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5ff8dda783ef735e6c8ba444b319b60b1e297f812c5b680f947780325643757c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8ed16c09ccca889e0a86d2823c4245bb82574abf65b18dd42bf1a77ccf300249"
    sha256 cellar: :any_skip_relocation, sonoma:        "41b661cebe6b49ddb5a4d454fe00cf4650b78eb4cb847663c08efad6c62239a6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "78446007f8c6e14588eebc97aa00e9d40ddbe2daa84628b36d7ecde7c50d0cac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c4700c54e78bbabc3596ff7f0ca8b00219799ae5131711e68c69329b6542cffc"
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