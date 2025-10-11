class Zuban < Formula
  desc "Python language server and type checker, written in Rust"
  homepage "https://zubanls.com/"
  url "https://ghfast.top/https://github.com/zubanls/zuban/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "1e1b265e4d4a642d2dfdac82d438ca6a1a777a0723489227eff1eb7c593816eb"
  license "AGPL-3.0-only"
  head "https://github.com/zubanls/zuban.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fd3d359e8687ca2dc22fe337203f6b4226076a4f1e2c72bad63376c591fe5d72"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6ad0c32d2f3cf879d3a5abfc9a0ea984503c30cb3fcc73913286b8e08fe578c3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6cb4515480269fdfa0df7a8154a37bfca0dc8a8d498646a0df43a988b5531262"
    sha256 cellar: :any_skip_relocation, sonoma:        "5240fa54682665b313c63f8492dfc20a38226a84cf962e8c2a2a60f0269d1f0e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e56031ec5e0cf91b47c51f49a2e13e8cb9a77fee3ad0e6ce3c07a32ee9a7175d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "32a19a9ad9d22e5ed095a279acc815842c25b81d639599498a5ae4249e6bba6e"
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