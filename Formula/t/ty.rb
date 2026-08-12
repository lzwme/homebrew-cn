class Ty < Formula
  desc "Extremely fast Python type checker, written in Rust"
  homepage "https://docs.astral.sh/ty/"
  url "https://files.pythonhosted.org/packages/58/ed/38a8ab52f1d7c3ed701442a31b23ba774cbc5d6909f2c00da9e1f3c590f9/ty-0.0.70.tar.gz"
  sha256 "a01bebc128b4081c16002965d906fccb21323d69bb709b9108c1f2406bcffced"
  license "MIT"
  head "https://github.com/astral-sh/ty.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7d817d990f292a074f37ad7261f347d359356752a5c58c922db081af9a61dfd0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "208073cf23827750312ba12065b9c8381b87d497feef4b22b6b7743b35f2cdea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "af83099e169d5a4ff7c7c35d3ba69fc730a7ca870bde8c22b030a552dc337f0b"
    sha256 cellar: :any_skip_relocation, sonoma:        "9ad47c5cc65399a0ccb56c1920d3591e51ad74a266273534089cbacf7b03e1e3"
    sha256 cellar: :any,                 arm64_linux:   "23f856d6a51f49d12f475153c2bf76158669440e2267ca785e6daa6de101eb50"
    sha256 cellar: :any,                 x86_64_linux:  "ec5a3ea0e7b9a91650aa2f8e8090a6fafc1ad6d460d54d8bcd746491126a282c"
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