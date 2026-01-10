class Ty < Formula
  desc "Extremely fast Python type checker, written in Rust"
  homepage "https://docs.astral.sh/ty/"
  url "https://files.pythonhosted.org/packages/bc/45/5ae578480168d4b3c08cf8e5eac3caf8eb7acdb1a06a9bed7519564bd9b4/ty-0.0.11.tar.gz"
  sha256 "ebcbc7d646847cb6610de1da4ffc849d8b800e29fd1e9ebb81ba8f3fbac88c25"
  license "MIT"
  head "https://github.com/astral-sh/ty.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "808c851c8f10d458eaad4199a879d2dcc794780772465ffa7c31d09236f23aef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "97c5088909a6cabe83c893545cfb16c24ac676a08c7974135630363fd0a70c12"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4c5f0467690c23ecb1a50177135ad5531f3bc60e202105ce3fbbdfc65b126a28"
    sha256 cellar: :any_skip_relocation, sonoma:        "361d585a46c5dda3a32c4ffd000718247f000cf54259f8866d084c5035384271"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "47936729be626044e014d932ba02eb5c2d026c096e0bf86a88c0f6404110185e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "096bf0aaca2cfca3605bddd5272352615102a61a78c8d2d5636295530dfa007e"
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