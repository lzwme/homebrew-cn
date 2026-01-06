class Ty < Formula
  desc "Extremely fast Python type checker, written in Rust"
  homepage "https://docs.astral.sh/ty/"
  url "https://files.pythonhosted.org/packages/19/7b/4f677c622d58563c593c32081f8a8572afd90e43dc15b0dedd27b4305038/ty-0.0.9.tar.gz"
  sha256 "83f980c46df17586953ab3060542915827b43c4748a59eea04190c59162957fe"
  license "MIT"
  head "https://github.com/astral-sh/ty.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1e4887902339070eb578c26c8189372895bc85e1048b8afac107aebc7dcca04e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1bea39af87fa8eaf8e1f063ed7e631362081d6755aa62e3fa85eeccb648d87f9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b3bcc814bc72d728ac25b2e3813b50fd3dda6852a9559a717bae53786a737219"
    sha256 cellar: :any_skip_relocation, sonoma:        "752cc84b32306a85bf5f9be8d8707f067aada3d118884478513e7c1ec6ef461b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b63c53b35188ea72b7c86cc94eead944993a2d3728785e2786f107b1d014d3fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "180b665f8b63d78eb9cd7055586d2b691f86cdc746c2169738c12a078f4f8331"
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