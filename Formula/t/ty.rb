class Ty < Formula
  desc "Extremely fast Python type checker, written in Rust"
  homepage "https://docs.astral.sh/ty/"
  url "https://files.pythonhosted.org/packages/f5/e8/303e333a45289c2f1f006661c9aa535de83b316a6bfc2d2f97ba815be143/ty-0.0.88.tar.gz"
  sha256 "5e3165a05b3757edd5a08b1fc6cb4a00c3b067100416d50afb2d13a5ec102206"
  license "MIT"
  head "https://github.com/astral-sh/ty.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "21605b4dc334b47afabc3c98cd4b73d1f533460e838b3027689069c00ec9d845"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "fc0eb11be3e3017b931aa7a186ecd71994af217cde33585d17a7857586c90dd0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "30a5d9d926a9a84520ec5bb380cb6a32935588c296096e04d7b5d5094c47750e"
    sha256 cellar: :any,                 arm64_linux:       "4a43c31f5913f2d842c63c427a1c805a10a0335bd26f7b044fe83ef425710ec4"
    sha256 cellar: :any,                 x86_64_linux:      "05aab0ae1806a4bff78e0cf5d16e4570ad65ad55a2d4e7833f5ba79344e2a59b"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    # The sdist prunes some `ruff` workspace members but ships the full repo
    # Cargo.lock, so `cargo fetch --locked` would refuse to shrink it.
    system "cargo", "fetch", "--target", "host-tuple", "--manifest-path", "ruff/Cargo.toml"
  end

  def install
    ENV["TY_COMMIT_SHORT_HASH"] = tap.user
    ENV["TY_COMMIT_DATE"] = time.strftime("%F")
    system "cargo", "install", *std_cargo_args(path: "ruff/crates/ty")
    generate_completions_from_executable(bin/"ty", "generate-shell-completion")
  end

  test do
    assert_match version.major_minor_patch.to_s, shell_output("#{bin}/ty --version")

    (testpath/"bad.py").write <<~PYTHON
      def f(x: int) -> str:
          return x
    PYTHON

    output = shell_output("#{bin}/ty check #{testpath} 2>&1", 1)
    assert_match "error[invalid-return-type]: Return type does not match returned value", output
  end
end