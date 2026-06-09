class Zuban < Formula
  desc "Python language server and type checker, written in Rust"
  homepage "https://zubanls.com/"
  # pull from git tag to get submodules
  url "https://github.com/zubanls/zuban.git",
      tag:      "v0.8.2",
      revision: "eb1aaf55eb1b4d8e17917ec436af416b413052c8"
  license "AGPL-3.0-only"
  head "https://github.com/zubanls/zuban.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fe74defc4c1c9e880c9647a42af15d6cbf1fefca702c2f81cd57da91fd338e6b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dba3de458bf35e84c18d171341059efff1a3492cd32109697b57e0beb2da85be"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1339df2137eb5475ee8268c4249447a144b444f657eb889ebdcb85029111d475"
    sha256 cellar: :any_skip_relocation, sonoma:        "00b0a6eba19e65826fd5de804925080a88dfb93791f5567a326af1dc4957d331"
    sha256 cellar: :any,                 arm64_linux:   "ddd430cf60de377d7f4782192479b3015e9a99f1f7b9de2fae5f2b78650e2ddc"
    sha256 cellar: :any,                 x86_64_linux:  "87f7c219530008a1216ffdfdc27e8639202ba4a040f48885f10a95022ec3ed00"
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