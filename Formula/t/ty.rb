class Ty < Formula
  desc "Extremely fast Python type checker, written in Rust"
  homepage "https://docs.astral.sh/ty/"
  url "https://files.pythonhosted.org/packages/14/bf/4baa1533937246861afcf27a84a3bbf1a536729fc40fdbbf6c99c4218dac/ty-0.0.36.tar.gz"
  sha256 "0350a4edc956f165ab1d1c92db3b74526fcaae16921095b63c3c6a8be313b2ff"
  license "MIT"
  head "https://github.com/astral-sh/ty.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c54382e55174c39916a9d066063dfee94dd688859116041e3032021005363290"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7ffaf1e9370584902c4036f40e3de11429b7e8598f8e7cc5603a399e3f17e6e2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2c460a00ebd14c68745ed565e1649b194211c27fd7948fac564eeeca831b6f54"
    sha256 cellar: :any_skip_relocation, sonoma:        "6e70dc421dc4a360e950e2dae558fceb14172b1aa0a9e01746535645ba75a510"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1d376601c667f2edf942ec5c1b4cdab0aa4ab66408570aad87cd748e3dfdd1b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "840803d2ba07226d7b5fc7d42ea14dda1935c988e9810164c4ea62cb18b65fdb"
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