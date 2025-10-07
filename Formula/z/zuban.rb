class Zuban < Formula
  desc "Python language server and type checker, written in Rust"
  homepage "https://zubanls.com/"
  url "https://ghfast.top/https://github.com/zubanls/zuban/archive/refs/tags/v0.0.25.tar.gz"
  sha256 "a898c5b05a7ffa155dda78dd85689a689d0ba0b312a8893a61bcdc0fd5b8a98f"
  license "AGPL-3.0-only"
  head "https://github.com/zubanls/zuban.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2af0b38d55d0907003faf67bc7bd205d432a366fac346f5ebc258f687662d73b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "15086e1f3d94b9399b86a35a92ffdbfdd860cf749b40472f054284dfd572c1a7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "04ccef07e2d12e880942f3e615b31424bb3f10d4655d6cd4658aabea6736c721"
    sha256 cellar: :any_skip_relocation, sonoma:        "728b59ff836307814c528f76d3c384ecc024aa486a5fbddc31fab37c05801460"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6ffa8468f1983713ccbd7a10e2ebd1bc1b548f0f997a15f7980d99d99ac4f0c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b91a31c0b1fb613729e1a58a5e932787ea404b7b21fc1e74e0c822ed499d78f4"
  end

  depends_on "mypy" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/zuban")

    # Work around zubanls not reading ZUBAN_TYPESHED (https://github.com/zubanls/zuban/issues/53)
    (typeshed = libexec/"lib/python3/site-packages/zuban/typeshed").mkpath
    cp_r Formula["mypy"].opt_libexec.glob("lib/python*/site-packages/mypy/typeshed").first.children, typeshed
    bin.env_script_all_files libexec/"bin", ZUBAN_TYPESHED: typeshed
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