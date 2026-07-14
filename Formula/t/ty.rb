class Ty < Formula
  desc "Extremely fast Python type checker, written in Rust"
  homepage "https://docs.astral.sh/ty/"
  url "https://files.pythonhosted.org/packages/95/b0/84ae7b3bf6e3e9f57eb9635eeff5a80b36e57aa089f40be0fb5c384fa176/ty-0.0.59.tar.gz"
  sha256 "53e53ffeed78ad59cd237fa8ea1316d2b94e13efdea9a945698acab549e005aa"
  license "MIT"
  head "https://github.com/astral-sh/ty.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "105978872dcdb6be0aa13ad56cab66a8e80ddacab0aa26581e72bfd304b17779"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "82407a0d92aeb83137c5e140fb86a5f7d3466df66ff137dd35e902ba59bcc370"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ffdf9e5789bb09bb688032cf5db9dcb2027aef3fc8d5c4bb2ea1dfdbdd618ca7"
    sha256 cellar: :any_skip_relocation, sonoma:        "1b6fbef2a14a3fc4238ab1dbc041f30ae8862358f55ae0f5c636fba17cf0685a"
    sha256 cellar: :any,                 arm64_linux:   "16edfffc5278891c2df1102713477cfc815f57029cb24fce2dc8ea91263a2226"
    sha256 cellar: :any,                 x86_64_linux:  "fe045c0d59867339be79b690a4036b626a2ad9dc4f4b24841223e1d39c0c56c2"
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