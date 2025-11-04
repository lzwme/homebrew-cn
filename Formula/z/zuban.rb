class Zuban < Formula
  desc "Python language server and type checker, written in Rust"
  homepage "https://zubanls.com/"
  url "https://ghfast.top/https://github.com/zubanls/zuban/archive/refs/tags/v0.2.2.tar.gz"
  sha256 "03ea108ea7d58eba2a157a381fb235fe7153228a38a4e38674f9a8cd071dfde5"
  license "AGPL-3.0-only"
  head "https://github.com/zubanls/zuban.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "82779ce4921b7d9949588f53ff7b63987ccf3fda4d2edfe10217f7a23f23aad8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e774c620b4fb957d2c25f14ed76f913a5fba09b6c3e675af4f08e0a2f99cb2a7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "da92f064345ba440af0d8f6b304d9230ac594aa72dd158136a6da19c4579fb70"
    sha256 cellar: :any_skip_relocation, sonoma:        "55c3d95981e71739dc3890a7ceb892a84dbba92b6fceffb0976811da4bea8582"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7c80f0e6460e0d2bd2fd14ffc43e16e9c80289d8a0d2bd18bf8fe666d52c6031"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0cfd9ab8367b5fe38adc7c931d68fb5fc07895a96572ebd0b5e5efe3c5ccfe4c"
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