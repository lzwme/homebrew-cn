class Ty < Formula
  desc "Extremely fast Python type checker, written in Rust"
  homepage "https://docs.astral.sh/ty/"
  url "https://files.pythonhosted.org/packages/09/4c/26c90732658903aeb1d289208f7b7b492fa21029e0c4d6c51bdd6f8f5e51/ty-0.0.58.tar.gz"
  sha256 "8f22484174e65c630660a454bf81b80cae7a3a7e70479f19c170d6cd87949258"
  license "MIT"
  head "https://github.com/astral-sh/ty.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2838be640c2db73b770754afbb48fb27e133d9c5c6ed04726f37f5c4a008e341"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "657d43ad4511bd66e0ec6d37b070f05cc67b7323d1367f669a597438978a73ce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e617ef9780cbd9e67a5d40a0b712db18610556f90763d931102b0855afdd317c"
    sha256 cellar: :any_skip_relocation, sonoma:        "c54a860daf951232842ba2197841eb68d79d4836363515bd32f631638b04b8ef"
    sha256 cellar: :any,                 arm64_linux:   "ec20c717b2a31d7729354e773651c7cc5656cefaae15be23f8a908333558f574"
    sha256 cellar: :any,                 x86_64_linux:  "e1d698ddc85bf968f023b8f02b250aae8292e1b334da2106d4c653ce49c58644"
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