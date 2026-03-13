class Ty < Formula
  desc "Extremely fast Python type checker, written in Rust"
  homepage "https://docs.astral.sh/ty/"
  url "https://files.pythonhosted.org/packages/f5/ee/b73c99daf598ae66a2d5d3ba6de7729d2152ab732dee7ccb8ab9446cc6d7/ty-0.0.22.tar.gz"
  sha256 "391fc4d3a543950341b750d7f4aa94866a73e7cdbf3e9e4e4e8cfc8b7bef4f10"
  license "MIT"
  head "https://github.com/astral-sh/ty.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "29c6fc0e82fcf07e7b8ca4d12457b039574e10e66a23e7ae46b66c7b17484d5c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d3c9f26eef3bb22b49fe79141ca8703162e65b2d4ad9a5df65cda4187c1a8fee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bce9df47cf8fce29b7f1de38adcd854dd397b188faa97ff5d38a56732684bd6b"
    sha256 cellar: :any_skip_relocation, sonoma:        "4d51d982c1c2e4791695d5d6a1511046161f5f616ec9151c2a1e7ed1bb184bca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "262ae3e064b71e93c3d5bab7dbe4368e4ef9affedbad43bb43ab52e8003ee179"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "93a764f6e28a9901434294a357b2a58eb8c94b0e21e140ecd92ba867bc12f6b2"
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