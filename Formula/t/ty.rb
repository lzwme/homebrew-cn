class Ty < Formula
  desc "Extremely fast Python type checker, written in Rust"
  homepage "https://docs.astral.sh/ty/"
  url "https://files.pythonhosted.org/packages/f1/fa/9b35728cc3c04d64f434c656836fa3c5f6e384a7813e48e63245510d5c69/ty-0.0.86.tar.gz"
  sha256 "6edcaf52e207d653873d5f495c1a8470075b232030714c981f07f0a1075bc343"
  license "MIT"
  head "https://github.com/astral-sh/ty.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "072ca77e197a61af2cede483691733c445bd8e6454ef2611157cbfb46683952b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "62a9f1ff4ea96e555f783ee3a207623639463e2d839a993861183fa0806ba421"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "16ffe70ce542d9cca07fa2fc434daa2cad211749d65655e90ecacecb6e4c722f"
    sha256 cellar: :any,                 arm64_linux:       "dbfba26c163c14e19a22afe3ef11521ebb633a3f4a843e102632191ad203c140"
    sha256 cellar: :any,                 x86_64_linux:      "224956e756d864c39f6c78198adfa72b9692f425fdeb701b8f5cdced1b0b851c"
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