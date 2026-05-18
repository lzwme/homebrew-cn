class Ty < Formula
  desc "Extremely fast Python type checker, written in Rust"
  homepage "https://docs.astral.sh/ty/"
  url "https://files.pythonhosted.org/packages/c7/c3/60bc4829e0c1a8ff80b592067e1185a7b5ea64608acb0c676c44d5137d52/ty-0.0.37.tar.gz"
  sha256 "f873f69627bd7f4ef8d57f716c63e5c63d7d1b7327ab3de185c7287a75223011"
  license "MIT"
  head "https://github.com/astral-sh/ty.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aa0fe301815baf466081887a0df54d2cce82c0e301f95d85ad36289d120014d4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "652638bc14c8a8efbaacb7c1a341d6566f158ea08339988ea6982e2eaf0de24e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cd63f904d0709d35b60ce6f9198d1883b2a28c0f2cea66d8a8c7c5b05c3ca562"
    sha256 cellar: :any_skip_relocation, sonoma:        "ce7ae786d4484f739e97cc59796b874c3c482fd160f3ea8d5d236b687eef0512"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a1d7e3871483c6bec50c307c0d6b7438224972eb9fbf9be47584629240c107d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "53f1e19d5e6460670b7fada6bf5a9e3019ede22690325a2c49eaef74c6911bfb"
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