class Ty < Formula
  desc "Extremely fast Python type checker, written in Rust"
  homepage "https://docs.astral.sh/ty/"
  url "https://files.pythonhosted.org/packages/17/15/8a1e8008a4580c3c7bbf2a2e1a6e0001abbd265728426ffe7fc3eab29e98/ty-0.0.87.tar.gz"
  sha256 "0f844e1fe0725a69753d22b46cb3dce653f3331ae8e332e46b0f22349a244093"
  license "MIT"
  head "https://github.com/astral-sh/ty.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "18c2b1fc1d44d08498bca53a051854b55b9a889833e0173373441366599e8025"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0fef99bc084a8fd66fa83a09a4597a9b8ab5c467caaeb924d97fd06e7048644c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a42c1b27c687f207cc28ab19c6089ae62de56c1252c783ae533e51012ca849f1"
    sha256 cellar: :any,                 arm64_linux:       "1f826f2253432ab6f0612e39d03c305a0f2f9cd98e0afff8019d21dc9f724902"
    sha256 cellar: :any,                 x86_64_linux:      "7fd5d29c0eed451ce9d4d0edc0226a79286407cecde0704ffb4bfd9cc518c2ca"
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