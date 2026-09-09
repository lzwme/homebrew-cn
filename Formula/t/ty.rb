class Ty < Formula
  desc "Extremely fast Python type checker, written in Rust"
  homepage "https://docs.astral.sh/ty/"
  url "https://files.pythonhosted.org/packages/b5/d3/4fff47468a976c7a5ded9fe350734ca09b9e8460750327f2245ea3288d5d/ty-0.0.79.tar.gz"
  sha256 "159a1aca70edebae32be08bfba2e5d543ffd8f9f380af160e0e713e85313b733"
  license "MIT"
  head "https://github.com/astral-sh/ty.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5bda20c4e00f4b9798a9e1d1dc926ec8a701369c1e10d250800941198663966f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c2d0b0aaee922849720ee706415dd7e6573467fc795ca877d7bd607cdd496487"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aac98f781ba15cc3eefa616e556983ebb4bc2a911bb811b89c76f229d99f1604"
    sha256 cellar: :any,                 arm64_linux:   "5717979bc48a9e882aba2118566c144c3d392fd2abd6e3ae3ca722ee7f7f4ec6"
    sha256 cellar: :any,                 x86_64_linux:  "d043345c7fd5b5ac78500b5441102f26e3ad56f028f1212053bcb01da4835b0e"
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