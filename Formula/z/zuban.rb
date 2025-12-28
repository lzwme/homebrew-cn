class Zuban < Formula
  desc "Python language server and type checker, written in Rust"
  homepage "https://zubanls.com/"
  # pull from git tag to get submodules
  url "https://github.com/zubanls/zuban.git",
    tag:      "v0.4.1",
    revision: "1535a3115970e1139b2bc60cfe4bca880d1a6090"
  license "AGPL-3.0-only"
  head "https://github.com/zubanls/zuban.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bded593c7e5f23910c7221c132c18812848ba576f93f54735b32bc023f4cf898"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f8cd32ef99652ac9796adc29578da4389936141481e821cd00927f052d5be049"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "636dcfe114c0fd4479b6ca3eafb47645d24dd8eb92c0f66b172ab234cef400ff"
    sha256 cellar: :any_skip_relocation, sonoma:        "594ec5f7f6bbe0368c0a48e96fa6d6a8b94d52edb78c2b0f12855f876ca8b6b0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a64e31124273b80d301dbc99344549add47a64ee4dc55becaec6eb2fd6d68951"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cafa6a8322041b1ad5139e9027cf0978a8aa118168089a5a543e61d1f3772e99"
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