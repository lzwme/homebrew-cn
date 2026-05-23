class Weave < Formula
  desc "Entity-level semantic merge driver for Git using tree-sitter"
  homepage "https://github.com/Ataraxy-Labs/weave"
  url "https://ghfast.top/https://github.com/Ataraxy-Labs/weave/archive/refs/tags/v0.3.4.tar.gz"
  sha256 "683162625ed7765a37621628090134e78a85ea2985e8f65b79b85ee9612c3cb5"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/Ataraxy-Labs/weave.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ad893ac057dccd8145505b2cbb87dd97c0c102b329edbf15552deb5b87a8898e"
    sha256 cellar: :any,                 arm64_sequoia: "91a57bd695f0dc6bf617ba24ff92de92efb8ac91a10545107082a923c521d9c4"
    sha256 cellar: :any,                 arm64_sonoma:  "9c6c53d0930899a7968eb9048239e1b64007b251d628db433cff46b46b47d99c"
    sha256 cellar: :any,                 sonoma:        "625edd5ea1b072ce293389114fd4d20aca8fed1269fc7078525b0c8326a55ab8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f2228fb9d74de532ac65d2ae6925f1e7e4f3f6450b2fbbc4685e92eb3abbd249"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fcdf7ba3206a619ba1663811140c69ca007bf40173b244f8346e45794a434cec"
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