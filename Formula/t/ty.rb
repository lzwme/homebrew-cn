class Ty < Formula
  desc "Extremely fast Python type checker, written in Rust"
  homepage "https://docs.astral.sh/ty/"
  url "https://files.pythonhosted.org/packages/d5/df/656e684bafb13c1d146e7d5b5f3e7978ca177232acc84998ff36427e9462/ty-0.0.72.tar.gz"
  sha256 "ec2b8066b618df18cab4cb8e992f8da45d360332acb23fa34df7fa29cd1b9d3a"
  license "MIT"
  head "https://github.com/astral-sh/ty.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7acc1041c65aa34b15f710044246da1daeada650a696b0541d03b264135ddf3f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c5c7b8b07b13cb058faf3b22fcc7c36b5e95e52a4e11937bf03ef4ebf3f13f7f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d921c33c8594f0021795a10a6f7ba0d49b10a0e0768de9e94e7bfb77a8335e7f"
    sha256 cellar: :any_skip_relocation, sonoma:        "6c688361f7f232fba33b8cdf5051f0a745ea724f20a0d740612fa1190f50deb5"
    sha256 cellar: :any,                 arm64_linux:   "58fe361e7c31902ec08170735f479b90e673f2bd5bed1bac4e9c933728a88289"
    sha256 cellar: :any,                 x86_64_linux:  "151f1b1811158173d16adb42b0762cb46d70fed32e03ff9c9586ddb78d064544"
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