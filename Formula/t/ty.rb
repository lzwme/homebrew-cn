class Ty < Formula
  desc "Extremely fast Python type checker, written in Rust"
  homepage "https://docs.astral.sh/ty/"
  url "https://files.pythonhosted.org/packages/75/ba/d3c998ff4cf6b5d75b39356db55fe1b7caceecc522b9586174e6a5dee6f7/ty-0.0.23.tar.gz"
  sha256 "5fb05db58f202af366f80ef70f806e48f5237807fe424ec787c9f289e3f3a4ef"
  license "MIT"
  head "https://github.com/astral-sh/ty.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "273637248cc4a4a7a7031c0e3e877e3d878ddf549cbfc19bb61679f673674843"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5c267e4e8128b3dd9e044be08fa8d6bf4f954975c9d387bc602e118c4f8dce5a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e69fde7ac42b06c5add77617c51c33ba6d00d0a5b28b5ea76a80a8ef9d9f5c80"
    sha256 cellar: :any_skip_relocation, sonoma:        "f550eceb73e314537f6f4fdaa4a27bdfc33d85bdb3d2e3728f627b1316f37a1e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1dfcaa0b2b910efc00d127a75679840d615cd0241d2c60041c8b05e238e90422"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a3ecd882a2ffc18e7bdbe98f17439b3029368f313b4d5bfdd7e085ad50cd4f5"
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