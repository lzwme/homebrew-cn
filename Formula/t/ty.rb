class Ty < Formula
  desc "Extremely fast Python type checker, written in Rust"
  homepage "https://docs.astral.sh/ty/"
  url "https://files.pythonhosted.org/packages/45/f8/2629d3533019eec56b0008d93198b2cb1575795e017c52759d6ddbdad353/ty-0.0.92.tar.gz"
  sha256 "d08ff5d89bb63780e30837446ea08ddae3db73ae0b872a441a5b514d37726459"
  license "MIT"
  head "https://github.com/astral-sh/ty.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f6459d598b81cf8e51cf8c262a726aa4890bdb234e035fb34e0794abd5977cd6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "49cf837c0008806fe8710a2bf901d58aa6a9e4bbc40dff85b75783768586104d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b52bd39ff4897438df520f1d93532460cb891e2a2f208ab3929d174f82d0ad11"
    sha256 cellar: :any,                 arm64_linux:       "cc8c8989c146151a8742dd7455435469fb6a32b8a3e67a3325ccb1b3ae175a86"
    sha256 cellar: :any,                 x86_64_linux:      "07840f56b3d2a83f8fa5ae290893977bad908d53f4fe5261c373155a447b97b6"
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