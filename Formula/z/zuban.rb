class Zuban < Formula
  desc "Python language server and type checker, written in Rust"
  homepage "https://zubanls.com/"
  url "https://ghfast.top/https://github.com/zubanls/zuban/archive/refs/tags/v0.1.2.tar.gz"
  sha256 "0c57207dc788a76a06a20a32f3228e9fdf94680cfade9bd367b134bcb55df717"
  license "AGPL-3.0-only"
  head "https://github.com/zubanls/zuban.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4be86171d123b1c1f29a3a1e89dd1b0a3032e6317f6c1e1f11227b372e4aa59d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c4210cdbe36e9bfbb495a2cde582e4e95bd47ca78760c3d0579607a644f5ac3e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0c3117cac31e5177ac70a1680351bb54dc88a38994ccea6ebe47f02a14ac8a25"
    sha256 cellar: :any_skip_relocation, sonoma:        "9de9b1ccee56bb292c3c3142964550867365c7853ad3e86684978332c4e4bb7e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "00eee2588e348c0b88150ce5e688e779d85457cb3ed65fcc3b145f28ab7ddba4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2fb742e9d1fc04bb1f76605aa6bd3284b82502947930eb39b8620a6193547cda"
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