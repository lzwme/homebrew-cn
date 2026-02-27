class Ty < Formula
  desc "Extremely fast Python type checker, written in Rust"
  homepage "https://docs.astral.sh/ty/"
  url "https://files.pythonhosted.org/packages/84/5e/da108b9eeb392e02ff0478a34e9651490b36af295881cb56575b83f0cc3a/ty-0.0.19.tar.gz"
  sha256 "ee3d9ed4cb586e77f6efe3d0fe5a855673ca438a3d533a27598e1d3502a2948a"
  license "MIT"
  head "https://github.com/astral-sh/ty.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7515d6ac2401b4dfc8dbbd3299d2a13b4551faef7c097aa8bf657554b908415d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f92e7651b8cfa1bd697f7431135f71177f2eaf91ab7797e6ba8d72bb69cbd4e2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "01931ebe4d2639817e006a6e435c6dc117877d2b7e9e52d596991bb2dee2a60c"
    sha256 cellar: :any_skip_relocation, sonoma:        "c95b5602a9281d351ecfbd0a20b5cbd7e62b6ffbd837aabc49dd14e0f76f25be"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "13693fd440112342f0db57b5ce8ff97ae37b98c150cba0a4080bb8d0e5711dc3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8516a6f20be2862293ed9345a1f77ad8ae5fb54c6c6f184028e8d1df3a25f491"
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