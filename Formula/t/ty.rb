class Ty < Formula
  desc "Extremely fast Python type checker, written in Rust"
  homepage "https://docs.astral.sh/ty/"
  url "https://files.pythonhosted.org/packages/68/b1/613b5534624442a9118828d7a9e54d50b16f0f5c8b67c80eb6623f33b921/ty-0.0.90.tar.gz"
  sha256 "25cef63ec07a0254c2f5d885a63b001d0bfa437b20caa0a408f4f52e66b133e7"
  license "MIT"
  head "https://github.com/astral-sh/ty.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7446c95bdcbf78ed5736c86f9c4153d75e27934246fbfbf31b125c11ae81ad9f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b6c3f512c8a40f504e3ef5f19b7010d9b7e3bd4781ce94887495d29780e4db10"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "54f247e1a992c1fd7a894cbe44edb785350cbc652d7036f65d91c2aa3f8d3be7"
    sha256 cellar: :any,                 arm64_linux:       "f238336623ec08a17d626e67104739a0f194cc243acf17a9aaea730c8256bda8"
    sha256 cellar: :any,                 x86_64_linux:      "e6df8ff42f901a5d87885dc19466a3ca49b59ec7e9045db2fead0cf42b2c6fcb"
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