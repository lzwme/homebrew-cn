class Pyright < Formula
  desc "Static type checker for Python"
  homepage "https:github.commicrosoftpyright"
  url "https:registry.npmjs.orgpyright-pyright-1.1.398.tgz"
  sha256 "c3c8d8199b95ac9368c113c1b289dc25bd192d7ff85073c048ea5e6b4ee5253e"
  license "MIT"
  head "https:github.commicrosoftpyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6f04a3dadb0a1cdd9629f6e8048e54f556f1b353ba0ed7ed3a9e6b3a1aeeaca7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6f04a3dadb0a1cdd9629f6e8048e54f556f1b353ba0ed7ed3a9e6b3a1aeeaca7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6f04a3dadb0a1cdd9629f6e8048e54f556f1b353ba0ed7ed3a9e6b3a1aeeaca7"
    sha256 cellar: :any_skip_relocation, sonoma:        "107956ad8c74cf7a0a074d407ebcdd347405053a03817bb7b088788a8adb7e40"
    sha256 cellar: :any_skip_relocation, ventura:       "107956ad8c74cf7a0a074d407ebcdd347405053a03817bb7b088788a8adb7e40"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6f04a3dadb0a1cdd9629f6e8048e54f556f1b353ba0ed7ed3a9e6b3a1aeeaca7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6f04a3dadb0a1cdd9629f6e8048e54f556f1b353ba0ed7ed3a9e6b3a1aeeaca7"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    (testpath"broken.py").write <<~PYTHON
      def wrong_types(a: int, b: int) -> str:
          return a + b
    PYTHON
    output = pipe_output("#{bin}pyright broken.py 2>&1")
    assert_match "error: Type \"int\" is not assignable to return type \"str\"", output
  end
end