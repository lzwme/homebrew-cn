class Weave < Formula
  desc "Entity-level semantic merge driver for Git using tree-sitter"
  homepage "https://ataraxy-labs.github.io/weave/"
  url "https://ghfast.top/https://github.com/Ataraxy-Labs/weave/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "0428b6f088c44da7aa17cc07fbbfc7cfe64f7ffe5a92c1918f1e4db874d0cf1a"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/Ataraxy-Labs/weave.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "cfc006b7e3175556b30e627fa903c362e08541d52f27730b86e8f958f6656e47"
    sha256 cellar: :any, arm64_sequoia: "eb71b7804c7dfa9dbbb72ca177c5c54531450f19691c9e81b3d26aa4e1280653"
    sha256 cellar: :any, arm64_sonoma:  "47e88a872e9bd2603245db1e6ebb507bfbb57c7793abef840086d9847a772436"
    sha256 cellar: :any, sonoma:        "4effa450f25fc20246dded69cedf0430168111be1323d049f69e5d76f3649d42"
    sha256 cellar: :any, arm64_linux:   "0656a8cd58e3b21bed13d73dc68a9953cb9a7d6c0774054d5ba624b2bc814309"
    sha256 cellar: :any, x86_64_linux:  "24bb65bfe995f034cdf281382fcae55d7ce60a8af20cb9b5ece246856c2b2512"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  conflicts_with "texlive", because: "both install a `weave` binary"

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