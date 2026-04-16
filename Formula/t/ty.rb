class Ty < Formula
  desc "Extremely fast Python type checker, written in Rust"
  homepage "https://docs.astral.sh/ty/"
  url "https://files.pythonhosted.org/packages/62/21/3ee32f163038ac2663c7bea47a07d06bf4cc7c09d95b96db194bda1b70cb/ty-0.0.30.tar.gz"
  sha256 "c982207640e7d75331b81031ebfb884ab858ed26ab16d7c086ac4942e2771846"
  license "MIT"
  head "https://github.com/astral-sh/ty.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3d77b08e7ce193dc1ad528274088c80829a02d66e8ba7b4b7de0ae14a47fc13d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cd0b71249933576c8706b6f1c615e918124c08eb5ae79e045b5cfb452b325e0a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b7a3363022b00daa5eb14a7cb282b44d5c2fcd0abdf1bc7aaf2ec920be07f79b"
    sha256 cellar: :any_skip_relocation, sonoma:        "06d97c21e1170c1c8336acc06bb0e346beb54b90826eb52786559f4a243b383b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bc9a6f3485f30e55f2b0fe3a63900e651471803baa876dde5945caeb13b88f84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e9835d04a828a26238da390c3b550d824baf6116a9988e076cfe92470993b08"
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