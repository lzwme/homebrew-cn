class Weave < Formula
  desc "Entity-level semantic merge driver for Git using tree-sitter"
  homepage "https://github.com/Ataraxy-Labs/weave"
  url "https://ghfast.top/https://github.com/Ataraxy-Labs/weave/archive/refs/tags/v0.2.7.tar.gz"
  sha256 "3ba0183c7805f1650a85b47cc6de46c6722cfc5d73744cf382a2ddf7c36558eb"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/Ataraxy-Labs/weave.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "34fafb45d64e5e6bd597f04850740ae2804645034cf2f96eedee7e6c6b77158f"
    sha256 cellar: :any,                 arm64_sequoia: "5b11bdbb2e077126c309bae9ac8675bf45e2d5793924ca5baeeece1112c34cda"
    sha256 cellar: :any,                 arm64_sonoma:  "4ddedd9c73f601f16182c68e8510cc39249ce026f4e09ab2fba0b2cb4ef76ab5"
    sha256 cellar: :any,                 sonoma:        "fc538cedb78774d023a70fe91762bd35e4dfd2f1a964503d7375fe34b68ade52"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a5122b298a095e1ffd2de60d75c72d4131e24968f2105645638b1f28b1f8040c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d9c25dc0a45c21d1c09055de65f875a5e209b2092c7c827faaa2649a3ab91ff"
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