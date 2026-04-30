class Ty < Formula
  desc "Extremely fast Python type checker, written in Rust"
  homepage "https://docs.astral.sh/ty/"
  url "https://files.pythonhosted.org/packages/84/44/9478c50c266826c1bf30d1692e589755bffa8f1c0a3eb7af8a346c255991/ty-0.0.33.tar.gz"
  sha256 "46d63bda07403322cb6c28ccfdd5536be916e13df725c29f7ccd0a21f06bd9e8"
  license "MIT"
  head "https://github.com/astral-sh/ty.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c10d6688287316952dee2a79d43f4c7c49a9afd890eb28daadd9fb286c3ec524"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6a4e1d8b6e408c48b95ac6277d84af35830e7da2f97e1411dbccc209c52070b5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1c8b31ae3c4163953eb9073194992c3983f2b9cbc80bccb9d51738d1ea5f68d7"
    sha256 cellar: :any_skip_relocation, sonoma:        "183981ec56dec2c16bb919487ba970b1d9599c50ab24037ec7d748ad249fdd46"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8a406d375bde54462fc80c071c0e77acd931d4d79e959f61ff807720333333d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b07d8eb38c9df0dc981d861492a5ff6106a0ccdfe1e8d1426485276c418bb18d"
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