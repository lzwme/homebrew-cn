class Zuban < Formula
  desc "Python language server and type checker, written in Rust"
  homepage "https://zubanls.com/"
  # pull from git tag to get submodules
  url "https://github.com/zubanls/zuban.git",
    tag:      "v0.5.1",
    revision: "d00773c2967b32a40d889171b85bab19f42256b1"
  license "AGPL-3.0-only"
  head "https://github.com/zubanls/zuban.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aec1e8ad4ec08bc7d503d6a28025a6c892b2e916fd94aa986866abb6f1510e09"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8f3873aa252895e205482676b94e3b7a637390e7496db4f26cb60c29bc19d6f1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8c42f3875b7236e9997e01d5b0b4d878d986c46a8541529060307d8f542d752e"
    sha256 cellar: :any_skip_relocation, sonoma:        "a635229b32e6a2aeb820ed2cd48497369fc089ac81f257e95b9a6c4c663a2e64"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "165750e90dbe77318e94ec0dde6b1c46a19869b87ebf1538e3d7af52401c22a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f0c9179708ad4125810c12e4d036573960f45b2995140ad54ee9b225819d3088"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/zuban")
    libexec.install (buildpath/"third_party/typeshed").children
    bin.env_script_all_files libexec/"bin", ZUBAN_TYPESHED: libexec
  end

  test do
    %w[zmypy zuban zubanls].each do |cmd|
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