class Weave < Formula
  desc "Entity-level semantic merge driver for Git using tree-sitter"
  homepage "https://github.com/Ataraxy-Labs/weave"
  url "https://ghfast.top/https://github.com/Ataraxy-Labs/weave/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "6d640e769e084ac08a13032d8d91ecc7c3767ccaa47d12020acc79f450c89ff3"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/Ataraxy-Labs/weave.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4fcf7302dd4758a5e39d403e059b0c9f137a1285bcc9c298bff7ddee0aeb210e"
    sha256 cellar: :any,                 arm64_sequoia: "dc2a2f4e61431b742eb80be541fb73a3b6d3b1b67807435b0dc74d099c933a3a"
    sha256 cellar: :any,                 arm64_sonoma:  "ae7208c46d16fe6f3b98f7fa6d9e173df94f17779201f4c94183269c4fb51469"
    sha256 cellar: :any,                 sonoma:        "f28aab9729959d3fdaed546b12dec2c242ffd3358472d3b5bef8d30f40943e59"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e73d8fc48a14d4f1f591f971638acbbc93cdd66f27779e1158678f9e5a970de1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eb75fd0c53e064c37197d0fb4205ae665f85476840212704ac30e370ed1f8007"
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