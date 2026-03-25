class Ty < Formula
  desc "Extremely fast Python type checker, written in Rust"
  homepage "https://docs.astral.sh/ty/"
  url "https://files.pythonhosted.org/packages/12/bf/3c3147c7237277b0e8a911ff89de7183408be96b31fb42b38edb666d287f/ty-0.0.25.tar.gz"
  sha256 "8ae3891be17dfb6acab51a2df3a8f8f6c551eb60ea674c10946dc92aae8d4401"
  license "MIT"
  head "https://github.com/astral-sh/ty.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "50eaccfc558b15115677f7516d7c1a89daee1bda10f1738344c90c474fb59a9a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2d04e88784787ce8d473ca6da32dda8c6673f253424c0449c2714845f6b0a665"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "58698e7bc84de300784b0f3f86793b4a5b94b1a93b59dbe38119e41b6f1b43f7"
    sha256 cellar: :any_skip_relocation, sonoma:        "b5d41f5d45546f74418620a6b3626445bed331530ec77ecb06b7b690e996b3ef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d0f0259cb0f6222c7f3a1ab157b8054c67c7051c9d8760ee4c3bd482359828ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f57befd02b6be5e6300bb127aaac639e2aa5f0b1a75eab92a090eee1e187320e"
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