class Zuban < Formula
  desc "Python language server and type checker, written in Rust"
  homepage "https://zubanls.com/"
  # pull from git tag to get submodules
  url "https://github.com/zubanls/zuban.git",
      tag:      "v0.9.0",
      revision: "392ea3ccc490071706d6736e2d5b2c07e6522386"
  license "AGPL-3.0-only"
  head "https://github.com/zubanls/zuban.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "05465d53000c90a78f1ea145d73625c2767fb5c98c0c1ccb1493408a2ce893cb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cd53af540c586296f1f23bd223a78ed179f89475d114fd30b170e2c5569b54bf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "05309ef5565bada1d4d274c43ea154a4c77b2b01f22bb4d9c6bb4132b784ada3"
    sha256 cellar: :any_skip_relocation, sonoma:        "9afcffa21d4c98caf070b74c79181d8802c241c5f45179c7fd7b597b14b0b205"
    sha256 cellar: :any,                 arm64_linux:   "3355062c89f5bf3864a7f35b2e5ae5310713df57d92be5b7817dfa47f94ec176"
    sha256 cellar: :any,                 x86_64_linux:  "6cc03bf8927bd507aee4d0630237c0bab3fa5538f4ca2c850c901fa2fcc8723a"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/zuban")
    libexec.install (buildpath/"third_party/typeshed").children
    bin.env_script_all_files libexec/"bin", ZUBAN_TYPESHED: libexec
  end

  test do
    %w[zmypy zuban].each do |cmd|
      assert_match version.to_s, shell_output("#{bin}/#{cmd} --version")
    end

    (testpath/"t.py").write <<~PY
      def f(x: int) -> int:
        return "nope"
    PY
    out = shell_output("#{bin}/zuban check #{testpath}/t.py 2>&1", 1)
    assert_match "Incompatible return value type", out
  end
end