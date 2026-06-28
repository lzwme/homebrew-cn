class Ty < Formula
  desc "Extremely fast Python type checker, written in Rust"
  homepage "https://docs.astral.sh/ty/"
  url "https://files.pythonhosted.org/packages/08/48/f687c8d268e3581f2f104d1f2ac5944d5b5e841b3695c613b3f263e5bbf7/ty-0.0.55.tar.gz"
  sha256 "88ca87073825a79a8327c550efcc86cec94344890244c5946f84c9e44a969f31"
  license "MIT"
  head "https://github.com/astral-sh/ty.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ead343c3564766191f6c408a05598e0bd9aae90e7ed10954b29ce0ca6e329172"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3150c8e69a2cbef3b2b4308cf3b3d32124f0ffbf52ea4a9d2f6d47619fff3e2e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5c1d5c18e2f6ea5b11d81fa50b9a740c9f561bd02bc2ddaec8d7ed2eaea82780"
    sha256 cellar: :any_skip_relocation, sonoma:        "06e558f808ddfc4fb8962fee6b0de8d9a3a5b441f225ca95688e9fed6b66a1ff"
    sha256 cellar: :any,                 arm64_linux:   "dc15219b0911b325cb9ddccbe8091f32f1260147ea30221c4e40362f1d9e9d5a"
    sha256 cellar: :any,                 x86_64_linux:  "dc7781c53c8ef1cf4a058ed510164ace442b0c4f1db750640e1f9518042da2d2"
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