class Ty < Formula
  desc "Extremely fast Python type checker, written in Rust"
  homepage "https://docs.astral.sh/ty/"
  url "https://files.pythonhosted.org/packages/d8/91/5b5ec4ed8721c18be8d9611778d7c07723cd755676f03b41bf0ea0caa5d3/ty-0.0.42.tar.gz"
  sha256 "70f5553ac678fc63558d4d77b08a18a68a228f44be2a2fe1afc3f5988db662e7"
  license "MIT"
  head "https://github.com/astral-sh/ty.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dc12ce5ca1889182a8ceae7f4813bf46f390c7ab16bd85627c227b5d3d1b3b3c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "95134c99df2b4040ac9b317f5e03d14d7e9a4290d08f38ddcd876ad34ae1e71b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4f4ec1dc6d66c064b69d49ccbf8f6075e9c3c26e8557c023caa5f18c090cff96"
    sha256 cellar: :any_skip_relocation, sonoma:        "1ed81b599406e6ea870ee3429bb2abe17ced639e0da0da4729663706bfae8a16"
    sha256 cellar: :any,                 arm64_linux:   "f3bb18196894a9854cb3a5d74bae0ee930bf5fcc9c0a92cee657a2641abc8d71"
    sha256 cellar: :any,                 x86_64_linux:  "b54da32203efc91d1c0534c661e7cd9d7f1e283c7b13f59a950176ee5c8b1198"
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