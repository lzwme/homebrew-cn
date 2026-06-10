class Ty < Formula
  desc "Extremely fast Python type checker, written in Rust"
  homepage "https://docs.astral.sh/ty/"
  url "https://files.pythonhosted.org/packages/5a/7d/d95b5a9dea83472006be3ce5e480028c44b34138d84d0172e910f287fb69/ty-0.0.46.tar.gz"
  sha256 "c6c2d7105b5633b49950b4c3a90d1ed2613eb9d794ad582bbbf6c4ffcb93accf"
  license "MIT"
  head "https://github.com/astral-sh/ty.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9858fe2b8257408a3ad9a9eec2c8d8bee44d60b2abd0264e96f8038a664a19b5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "323cff1f4a72377e86c1690a87b5166370e735b9abcd40e13d18db98add52275"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4687aa7f87dd878690913ebbfedbff85922f9599f6a0df22f59e26cf069abb05"
    sha256 cellar: :any_skip_relocation, sonoma:        "6a2eada8c7f68d21024ae36f83399279ae8dd5b46b1931a511a16293c7f283f8"
    sha256 cellar: :any,                 arm64_linux:   "ba65328f5772be68fc81652365fe1002fa2eb59b6f673822a42e8b9b0bc6bc62"
    sha256 cellar: :any,                 x86_64_linux:  "c35608f2147f65b48f803433a3c0323ddcd6a4988567ed3854733a7329f2a192"
  end

  depends_on "rust" => :build

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