class Ty < Formula
  desc "Extremely fast Python type checker, written in Rust"
  homepage "https://docs.astral.sh/ty/"
  url "https://files.pythonhosted.org/packages/61/b7/c9d736f48585f5a711ea47bb97a353d3771834f89481d747ea9687b74fa9/ty-0.0.81.tar.gz"
  sha256 "ef721aa649bf41d665ba86e1ea726fd3feab6800e2c4887a062a704baf304ca8"
  license "MIT"
  head "https://github.com/astral-sh/ty.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c2c2e6948588b690ef7cdd5ab27d4a459cb3ccfa467060b6d1219830f29416a5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e72137653c27328360dcce6cf3c050bf56d529c6305010811310e76d098a553c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "37901efecaf90ec2d80ba3a70259479deb05fcf37530c03282e9e01e0ce5fab9"
    sha256 cellar: :any,                 arm64_linux:       "237c945d845400345e96520a5404f37063c6d16372c09e8c0c44d9d5f26afef5"
    sha256 cellar: :any,                 x86_64_linux:      "ad05e0d726e8276768948067134b28992017dd880e10396d798eaa701e822a1c"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    # The sdist prunes some `ruff` workspace members but ships the full repo
    # Cargo.lock, so `cargo fetch --locked` would refuse to shrink it.
    system "cargo", "fetch", "--target", "host-tuple", "--manifest-path", "ruff/Cargo.toml"
  end

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