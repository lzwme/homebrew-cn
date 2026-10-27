class Weave < Formula
  desc "Entity-level semantic merge driver for Git using tree-sitter"
  homepage "https://ataraxy-labs.github.io/weave/"
  url "https://ghfast.top/https://github.com/Ataraxy-Labs/weave/archive/refs/tags/v0.6.2.tar.gz"
  sha256 "e1370c274d4981dda7f4f1dacb834ff4bf5ee1f8b0a820259fc4b3e9348974e0"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/Ataraxy-Labs/weave.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "027fb9fc1b6b231a6b030c93b1f593ec8a4ae8166638b8fdf6ea2f5199615e54"
    sha256 cellar: :any, arm64_tahoe:       "45b6c78b39e53950e07452fa926f3a43099e1ed8de2ec0dc54d924ff4feb3d70"
    sha256 cellar: :any, arm64_sequoia:     "441d2cc71520d3c2effcb0615081f0e4d445710f058907eda9c45a3a2fbe3f31"
    sha256 cellar: :any, arm64_linux:       "b42979991974fcb699af6b111a63f95525fa632ba1e5aa79313d437f69c6e417"
    sha256 cellar: :any, x86_64_linux:      "17c04f442923c875b28d5f6aa3866c4876361651cc57b6c5e078f811abfdb2ab"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"
  depends_on "openssl@4"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  conflicts_with "texlive", because: "both install a `weave` binary"

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/weave-cli")
    system "cargo", "install", *std_cargo_args(path: "crates/weave-driver")
    system "cargo", "install", *std_cargo_args(path: "crates/weave-mcp")
  end

  test do
    (testpath/"hello.py").write <<~PYTHON
      def greet():
          print("hello")

      def farewell():
          print("bye")
    PYTHON
    system "git", "init", testpath
    system "git", "-C", testpath, "add", "."
    system "git", "-C", testpath, "commit", "-m", "init"

    output = shell_output("#{bin}/weave setup 2>&1")
    assert_match "weave", output.downcase
  end
end