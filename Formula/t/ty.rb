class Ty < Formula
  desc "Extremely fast Python type checker, written in Rust"
  homepage "https://docs.astral.sh/ty/"
  url "https://files.pythonhosted.org/packages/56/95/8de69bb98417227b01f1b1d743c819d6456c9fd140255b6124b05b17dfd6/ty-0.0.20.tar.gz"
  sha256 "ebba6be7974c14efbb2a9adda6ac59848f880d7259f089dfa72a093039f1dcc6"
  license "MIT"
  head "https://github.com/astral-sh/ty.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f4ce68e9b91d20b27935f0529dcfb26857723b1a50b96ab6eb5f1cfdde1ded71"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2555069100bb2989f9ffc38323f0b3c27d67478a5ffcd961d57109639ba11767"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ed2fafd1da31ad43b747f243380001038dfb3e2607f9519a6adbccc264086d19"
    sha256 cellar: :any_skip_relocation, sonoma:        "08cbfee4987a2c85a3509336c4296954c880439adcffa143ebb0eca1854f1298"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "934bb67980ecf96d203c4db501b47513236a709099933cb12ec3010ff2674a63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "85de7ab2e3e7b9f38aaa651a8d7cb636e988300fc63c0d7b094206e3c688849c"
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