class Ty < Formula
  desc "Extremely fast Python type checker, written in Rust"
  homepage "https://docs.astral.sh/ty/"
  url "https://files.pythonhosted.org/packages/b7/85/97b5276baa217e05db2fe3d5c61e4dfd35d1d3d0ec95bfca1986820114e0/ty-0.0.10.tar.gz"
  sha256 "0a1f9f7577e56cd508a8f93d0be2a502fdf33de6a7d65a328a4c80b784f4ac5f"
  license "MIT"
  head "https://github.com/astral-sh/ty.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "799fef119b5339ea4cfa3130f103f89f5dbf5a07350106ac17fc359791a9e2fc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6a5107370f0f0bd747f0bd75203e574854b89d71e7e48386967d550067d24521"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ba4a30cc2a309c6781e84bdbf3ec111b89af3a399a016a969492172c9cba0749"
    sha256 cellar: :any_skip_relocation, sonoma:        "aca13f8d9c0f231fc8a5fddb247a99a56538d5a21fcb748f8dfae74216ffa342"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "de1fa671c6df96fbacc0e57bead8518c426c0420df02f0efeb6fb749d03afec6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8002dd02575375bf7d123e5cefec0adb8bac7b0b2cc4c3468749e1e35492c6d5"
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