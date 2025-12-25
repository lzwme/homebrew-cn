class Ty < Formula
  desc "Extremely fast Python type checker, written in Rust"
  homepage "https://docs.astral.sh/ty/"
  url "https://files.pythonhosted.org/packages/b3/43/8be3ec2e2ce6119cff9ee3a207fae0cb4f2b4f8ed6534175130a32be24a7/ty-0.0.7.tar.gz"
  sha256 "90e53b20b86c418ee41a8385f17da44cc7f916f96f9eee87593423ce8292ca72"
  license "MIT"
  head "https://github.com/astral-sh/ty.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "884269f4c0d4b43b69f2e56dbeeef71034741e03bf64c42d6fb5b1dfd5406faf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c8fc04c5c6e94158da2523d45437165c685d84e1734e4d4bb03dfa24c966c0de"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b61ddb8b2ef56d0bcd011200d003a18164998a5e60a4eccae35a3ba15b6c4998"
    sha256 cellar: :any_skip_relocation, sonoma:        "1bbaa56c24de5a571f0e9e52277730cb76dc7f93ce56eb56842be07527f5a2a2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2ef946d98c802330bc84881b1520a2cfe9003f1eb7911a599947bdfc7a2d63bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0dd0b5a169c6d8af70888d2e4f42657e32c70f38ef67880c2d3bc46b1d146648"
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