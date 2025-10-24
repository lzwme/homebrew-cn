class Zuban < Formula
  desc "Python language server and type checker, written in Rust"
  homepage "https://zubanls.com/"
  url "https://ghfast.top/https://github.com/zubanls/zuban/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "4b3dea37a219933b27a20ce963c7a3d935bf53c720215b1acda2d4feb01c340c"
  license "AGPL-3.0-only"
  head "https://github.com/zubanls/zuban.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "004be2411073f3f496c2c45c4108d03aa3e1027c313cf4261fad3c4f3da32273"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "98f549f5f21bb3f5e0fa97063ecef1d86763c27ec3d07753ce9c141b3700846d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "94d5f9e4f911a8e3310137f7b4c27275f835d828c2370dd84df13b7d9719cacd"
    sha256 cellar: :any_skip_relocation, sonoma:        "b5b333d8bddd528aa7dc1be87759fe62b077f1d6e949844c15cc2f7b8deb6c7c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c6e4f8153feb1afb092dcbead52d97a5603d669b85119653e56c0aea500c5769"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "23f5d9db13a00f02e31cddfdedb19c50f8e6faad42658de81421eb41ff93b932"
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