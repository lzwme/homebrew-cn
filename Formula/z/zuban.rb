class Zuban < Formula
  desc "Python language server and type checker, written in Rust"
  homepage "https://zubanls.com/"
  url "https://ghfast.top/https://github.com/zubanls/zuban/archive/refs/tags/v0.0.24.tar.gz"
  sha256 "b9982938f63f1569eb88ce0ec623a7b89e020d011b55894a7590693d0eee644c"
  license "AGPL-3.0-only"
  head "https://github.com/zubanls/zuban.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9be116467c99bb220805a08675e2ca369445950a99aaf8e11bf454ce98a267bd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0642961c33798ef05b2f66082463e1107d1e58ce3e71eb07802d0c2877e36c89"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2b7e29c882e2c1f742bb49f6141c1d7138984cacf455db2d426d9cafb523aac6"
    sha256 cellar: :any_skip_relocation, sonoma:        "b30176fc37fea3dc96efdaebe9f70c04e8ddb839a27e1e9673b43ea66669bd85"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "09fb22085b56d63f3041d91a5de4b4187206d23eeb905b45f2a5ed26fd62a5fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b301d092b3439afa2af2e02a4313f0fd25b55f08bf3989744767032e1646f99"
  end

  depends_on "mypy" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/zuban")

    (lib/"typeshed").mkpath
    cp_r Formula["mypy"].opt_libexec.glob("lib/python*/site-packages/mypy/typeshed")[0].children, lib/"typeshed"
    bin.env_script_all_files(libexec/"bin", ZUBAN_TYPESHED: lib/"typeshed")
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
    assert_match(/(not assignable|incompatible|error)/i, out)
  end
end