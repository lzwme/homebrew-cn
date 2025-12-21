class Ty < Formula
  desc "Extremely fast Python type checker, written in Rust"
  homepage "https://docs.astral.sh/ty/"
  url "https://files.pythonhosted.org/packages/9e/db/6299d478000f4f1c6f9bf2af749359381610ffc4cbe6713b66e436ecf6e7/ty-0.0.5.tar.gz"
  sha256 "983da6330773ff71e2b249810a19c689f9a0372f6e21bbf7cde37839d05b4346"
  license "MIT"
  head "https://github.com/astral-sh/ty.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a03c3902f941dcf0bed7b0dd272fc056b2b49f70a3c3db1d94376b9ed21cc36e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "44bffde4b6f019451ed84089e0b3776733a0653eb7a00a00ff001831fb9b702f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "945b92bd5373c1d973be6a6a25004a5dba31bdc99a19b07fc711c99c0f0572c1"
    sha256 cellar: :any_skip_relocation, sonoma:        "0642c9cccdbbe60c1cfd2e89f3633e626630c716205a0d443d5ebcd38a33298a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a6b46439fc4f9914ef0d6ffeef2b678cd9f04114c2981bd624af5ca26882e1d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7a1e838e6b2656e12453b511f1833a2c3992ef8a327a5b46751b4d50ad617e00"
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