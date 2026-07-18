class Ty < Formula
  desc "Extremely fast Python type checker, written in Rust"
  homepage "https://docs.astral.sh/ty/"
  url "https://files.pythonhosted.org/packages/0a/6e/1ab6f2727622d38ddfb2a7f994209b3087190b76885e2f754dbb6e58e0c9/ty-0.0.60.tar.gz"
  sha256 "ebd7517d1aa8d8c3793cbf03c263679a42b939eca650df583234f92a5eb5837a"
  license "MIT"
  head "https://github.com/astral-sh/ty.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3a53c63f6d80d4472128bb0b5c912461f322cc37dfe6f033d29f3430b9857194"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9f9cb7442b15a5a1ef53ecefc07a190adff2e07c8bf3166888e7cf1397553387"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "684d9edc217593f9ecc9778a204f5b4be086f982f32fd455827835b19c7710ff"
    sha256 cellar: :any_skip_relocation, sonoma:        "679764c6829d2c101368af14087a63d129a68ecf814294bd34335a1796eb1ed1"
    sha256 cellar: :any,                 arm64_linux:   "14bcbeb71c168f6213d762adf0f57e6ec751ae965c206219ee197c5055777358"
    sha256 cellar: :any,                 x86_64_linux:  "19325aa475a9452f5b7dfd2932f1f3e8a4140ecf5e21f19734bb006ae4036e61"
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