class Ty < Formula
  desc "Extremely fast Python type checker, written in Rust"
  homepage "https://docs.astral.sh/ty/"
  url "https://files.pythonhosted.org/packages/af/57/22c3d6bf95c2229120c49ffc2f0da8d9e8823755a1c3194da56e51f1cc31/ty-0.0.14.tar.gz"
  sha256 "a691010565f59dd7f15cf324cdcd1d9065e010c77a04f887e1ea070ba34a7de2"
  license "MIT"
  head "https://github.com/astral-sh/ty.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1f16eaee8f5d272011ff20ef40dafdbcd24d8f40aa4c172d08b6d88928816db0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "26cb0b5482cfd96211e52db032fbc33cb8d7f085476a333d5d95511187aabccb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7cbca8d0365803d49fbda48576bc7122da2358ceb03e1feaf89d3f3c55a5d92a"
    sha256 cellar: :any_skip_relocation, sonoma:        "1e8442babce7029f2263056c2f7a9cf4dbf28d0eedd5cfaf0f3b7ceb05be6bea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1fe46c25fcb53ff237748091bdda2fd3a8d6825a54f80088a30c3ac37297a202"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0f6d032ee434ceff0739e7e2426e91b4d8116414fd375a0fcc15b6aa573b416d"
  end

  depends_on "rust" => :build

  def install
    ENV["TY_COMMIT_SHORT_HASH"] = tap.user
    # Not using `time` since SOURCE_DATE_EPOCH is set to 2006
    ENV["TY_COMMIT_DATE"] = Time.now.utc.strftime("%F")
    system "cargo", "install", *std_cargo_args(path: "ruff/crates/ty")
    generate_completions_from_executable(bin/"ty", "generate-shell-completion")
  end

  test do
    assert_match version.major_minor_patch.to_s, shell_output("#{bin}/ty --version")

    (testpath/"bad.py").write <<~PY
      def f(x: int) -> str:
          return x
    PY

    output = shell_output("#{bin}/ty check #{testpath} 2>&1", 1)
    assert_match "error[invalid-return-type]: Return type does not match returned value", output
  end
end