class Ty < Formula
  desc "Extremely fast Python type checker, written in Rust"
  homepage "https://docs.astral.sh/ty/"
  url "https://files.pythonhosted.org/packages/cd/58/4f6ab2a86589e422a3cf840bcf6114c565e4c39ddf4d0b7cd328af5b52b4/ty-0.0.66.tar.gz"
  sha256 "24bddd4479ce445b51ac015410dd2d34af1cadd62a77f5b3cb269149ed83f9b5"
  license "MIT"
  head "https://github.com/astral-sh/ty.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "34ec0ebd5f487449566964c6efcf05b68fc89ceb92e9a3851f48f1aeba9223d9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6d47e58a7c9a4c13534e1de8082e3f860bf4ba2439475d29ef7c383a136bc038"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4a6645d0cd8b0fc5a3505d3a78423013185546fd4583fb5b0cdd4075087aa46a"
    sha256 cellar: :any_skip_relocation, sonoma:        "d6c44837c9276c3be996540a89969f5fab56314e42bad31ba47af31ef2761fb7"
    sha256 cellar: :any,                 arm64_linux:   "480629be95193f058fff20968061e74f814eef1ad1f71090e97a4744369be49e"
    sha256 cellar: :any,                 x86_64_linux:  "7247bcf24daf3c5e3cfd40f36f227f0791e747d7ff662272a559ceb82d8c339f"
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