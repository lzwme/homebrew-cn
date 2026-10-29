class Ty < Formula
  desc "Extremely fast Python type checker, written in Rust"
  homepage "https://docs.astral.sh/ty/"
  url "https://files.pythonhosted.org/packages/78/35/e1cbce56e80f6d911b6b6821d211b4150d0e061d426df038cad78d2800f4/ty-0.0.93.tar.gz"
  sha256 "18b99060d7f1d601fd4ce1acdcc336d1b3345fea8561307948827e8809c31c25"
  license "MIT"
  head "https://github.com/astral-sh/ty.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3425cc28f243c58723bf082fb4fcd375875aa6b2ee0c9bf6c28f45a3785dc087"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b7d69ccd2357b80fcb4634ef977191f9c3b655b9d71f1255d78ab6e91a91d705"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "adf6e086543283e08ffd9c78073beec70a383609c8f8ce55a10d9286092989ec"
    sha256 cellar: :any,                 arm64_linux:       "9e5e7e119ddad93b0200532549ac2df9662859f064001996601bfece037a009e"
    sha256 cellar: :any,                 x86_64_linux:      "1425dfe23d2a318f8f9367aadaec2a9fd6d2a8be6206218f5f00c003baf35fac"
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