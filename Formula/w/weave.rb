class Weave < Formula
  desc "Entity-level semantic merge driver for Git using tree-sitter"
  homepage "https://github.com/Ataraxy-Labs/weave"
  url "https://ghfast.top/https://github.com/Ataraxy-Labs/weave/archive/refs/tags/v0.2.3.tar.gz"
  sha256 "60c3cf0bacc7593d64ffde2d5d5720d93634e0c87778f4654a02b4903f00e8a4"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/Ataraxy-Labs/weave.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "09615be0816d3f36956db08308083f9f91d53bfbb8ede1f1c0ea93eeec951739"
    sha256 cellar: :any,                 arm64_sequoia: "9e7dc341726028ff45792f373a74958440d5eb315dd3db48b67e6615cb90ad6c"
    sha256 cellar: :any,                 arm64_sonoma:  "2e0e17314569bc4e153ff3b2079190c77bf7faf3d14b5fc6c78b9c5a1fde0bc8"
    sha256 cellar: :any,                 sonoma:        "2fd42b337768ffacd1cb7a385d3441fa5ce0f05cef70de9553c679abbe2cb0f4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c9ed0be611e8a2947163b8e2435e8481824f08f0d1ffe801afd67d823e6fbd56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "516b2472943365e73cd9431775a4b5cd1e05471522d0f0df24fb2439e75a751d"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/weave-cli")
    system "cargo", "install", *std_cargo_args(path: "crates/weave-driver")
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