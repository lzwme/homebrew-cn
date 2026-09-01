class Weave < Formula
  desc "Entity-level semantic merge driver for Git using tree-sitter"
  homepage "https://ataraxy-labs.github.io/weave/"
  url "https://ghfast.top/https://github.com/Ataraxy-Labs/weave/archive/refs/tags/v0.5.3.tar.gz"
  sha256 "2d6caa929fcef6aa0b51c9f22530c04e490472b739e4ce36a02af8ead4c6c68f"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/Ataraxy-Labs/weave.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "7ecdd2668842f50289292ea898a46f5e1cbd95eb9bdf5193af2bf633e039c68e"
    sha256 cellar: :any, arm64_sequoia: "cdb9ab7255cec92eb206bbd48f398e9a82badab899998e6585843c1a8ae719d7"
    sha256 cellar: :any, arm64_sonoma:  "28b83e7cd462ab46787d16a9a521f4539b3f377476ea5b3472496c98f4bdc0dc"
    sha256 cellar: :any, arm64_linux:   "b649e34b9a0ac5e025f304b1808d839bc907c7e9712691a5f62007749573bd11"
    sha256 cellar: :any, x86_64_linux:  "e5f538800028538ba4fdc3c17e8078e13bc9ceb25ccf0d85957cbc58488f50a2"
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