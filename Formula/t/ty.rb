class Ty < Formula
  desc "Extremely fast Python type checker, written in Rust"
  homepage "https://docs.astral.sh/ty/"
  url "https://files.pythonhosted.org/packages/8e/aa/14c9965d3b173105692473897cc89c34cd91241368b2044e43167e1c17ff/ty-0.0.64.tar.gz"
  sha256 "d12ddbb05f15158bb518af619378b385486450def95fb06f8ab98037febe9f2c"
  license "MIT"
  head "https://github.com/astral-sh/ty.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "75c913aecfe3973015f5b1094a341492334e42ecd1410baa7689035a1e626049"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "43bff8f9d8bd3487384dd770c1d684227579a9821e7197602e1a27399031423e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9ea9cc462bea4017fc13fb6c6b87fa450d410e010504eb518b2878a41c44946f"
    sha256 cellar: :any_skip_relocation, sonoma:        "d1edb77f6c8e2ca7939cd96632625100e009c92882434d7bbd4701b0e7c0d904"
    sha256 cellar: :any,                 arm64_linux:   "900c6aa5f4cf475489070d0971c92583e71e201ddbfdace9c5f63baf616af771"
    sha256 cellar: :any,                 x86_64_linux:  "10ae3da864ae9fb140a7c567c3b27805f4eca258c3b086475651510b3eeefd02"
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