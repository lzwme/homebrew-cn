class Ty < Formula
  desc "Extremely fast Python type checker, written in Rust"
  homepage "https://docs.astral.sh/ty/"
  url "https://files.pythonhosted.org/packages/18/94/4879b81f8681117ccaf31544579304f6dc2ddcc0c67f872afb35869643a2/ty-0.0.26.tar.gz"
  sha256 "0496b62405d62de7b954d6d677dc1cc5d3046197215d7a0a7fef37745d7b6d29"
  license "MIT"
  head "https://github.com/astral-sh/ty.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f394efb55bc8b232dcec47aa0071e4e1603a123b84a7d12b659a55df1f7291cf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c6e85638654e0ea99a4f0824fcc1b9eb9822fc9b5993b86d113d7d9bbdb775db"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8c6fa243dc3d5e9733f2d2100b080a0b440ac8a37b67b011e29bf803cff84ae7"
    sha256 cellar: :any_skip_relocation, sonoma:        "f3143193456ceaefca7675b040d3db758469dd43abf1c9d479ce7c8cdf5fb7e1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6d161d0b7b6f54a9c341299435e7da9efd850e60b9b287a60028c49fd0ea96d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "55842b111b9480057ad66cb547afc5bad5b4c75e424d921ed90cfc0a8be43bb3"
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