class Ty < Formula
  desc "Extremely fast Python type checker, written in Rust"
  homepage "https://docs.astral.sh/ty/"
  url "https://files.pythonhosted.org/packages/19/c2/a60543fb172ac7adaa3ae43b8db1d0dcd70aa67df254b70bf42f852a24f6/ty-0.0.28.tar.gz"
  sha256 "1fbde7bc5d154d6f047b570d95665954fa83b75a0dce50d88cf081b40a27ea32"
  license "MIT"
  head "https://github.com/astral-sh/ty.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7666b6645069de6ce121d921734f611d2bd3de1653c4903818bbea0020c0fc9e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fec9b98d5128ee73417b58cbaae6d46ea8b46182b1e5fb8f03ac68bd0c81a955"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d0940f9eda55c71c1293c407bb44d123bba48b7e955fac02d7fcb7ffa4e05c86"
    sha256 cellar: :any_skip_relocation, sonoma:        "dadf06720b22f3d1e3b7cd3b45171c8f4dd706edaf10de613acb0771ce8be7c2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e27fa2694f459639848dbf2615237dcb80337f478510f79d8de84f64332f1427"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c18f2f1fd2d952e936a5136f9d68d390a659817885912d0efbac07bfd123fd2a"
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