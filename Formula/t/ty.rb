class Ty < Formula
  desc "Extremely fast Python type checker, written in Rust"
  homepage "https://docs.astral.sh/ty/"
  url "https://files.pythonhosted.org/packages/5a/f8/a754c96967b71de8723f88be17df8738216bd382ffed229cd500b7a24d13/ty-0.0.40.tar.gz"
  sha256 "883b53dd98f6e5b33ab1c8e1a3cd94b0f29c762ef22cdf1e86aaffb4fd711c67"
  license "MIT"
  head "https://github.com/astral-sh/ty.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f37e2d6ce935538924dc71e007121a9515909bbd0539bbf8f75c67b220f63e1a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5ad641fd5dfc8be038f97e360d3d08624f005474ce9752547cda78d4524d70fb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f40937582836421db09d783cbfcf83e06c2bc33b034fef97c5f78ba708a836da"
    sha256 cellar: :any_skip_relocation, sonoma:        "2780fe2b41f05ff680c34eddea245207f74522fd51df458caf0893488f97fdb8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eb3582bb848d1efa29c21f202cbf0270028f2fe0f0626c16ca8bcb2e149be0db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9530a97f84b45ad0c8468b72b923c47ab58efdff2da3a21624e3982942373f26"
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