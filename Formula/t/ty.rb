class Ty < Formula
  desc "Extremely fast Python type checker, written in Rust"
  homepage "https://docs.astral.sh/ty/"
  url "https://files.pythonhosted.org/packages/0d/37/4ec04de0659b93be37d956dfceca13b1ecab9c959f28d8a1d5e514603f36/ty-0.0.43.tar.gz"
  sha256 "ea4cff50548f2a1877e848d3abe9e293cde8ab94757a7eb93fc0d4013f98be8e"
  license "MIT"
  head "https://github.com/astral-sh/ty.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "653ecf4e233466bb91991ee8caa27282302f1d0c0fbefe9b4cd6ef1d31a9e648"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c9b8cc98f2e8188d3794c002bc7f44dae2c99770656fbd2eb431b1e5d0772da6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c7dfa0d660af528cff0d6df850f0f3fa862deb3da86f53e820deb9b6ba6593a4"
    sha256 cellar: :any_skip_relocation, sonoma:        "5e2d1ceee53f7cfd0cfe31752bb441d1d1b22f7b15db4e91f4fadf0ba45aa4a2"
    sha256 cellar: :any,                 arm64_linux:   "b9ae05c265da641c36750e95d9c2b6966d92db7bc9fdb7f656a2ba006ea891aa"
    sha256 cellar: :any,                 x86_64_linux:  "0d3385f12a95370f07eb742e3fa81d6126d66af7493b7e198e35b764cb6e06d7"
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