class Pyright < Formula
  desc "Static type checker for Python"
  homepage "https:github.commicrosoftpyright"
  url "https:registry.npmjs.orgpyright-pyright-1.1.387.tgz"
  sha256 "0381525a5c3abf97b3f9423816c7bff2b27aa7dbda56c1c5d49b4e5ff55604f6"
  license "MIT"
  head "https:github.commicrosoftpyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4cbf68ee1cac66980a9c59042149e18962499b2ecc886fadd6ffabaccfe7341a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4cbf68ee1cac66980a9c59042149e18962499b2ecc886fadd6ffabaccfe7341a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4cbf68ee1cac66980a9c59042149e18962499b2ecc886fadd6ffabaccfe7341a"
    sha256 cellar: :any_skip_relocation, sonoma:        "4ba551506a2ceeffe536f958f9437178dee3dfbbb40593d4923449dcd60e48f7"
    sha256 cellar: :any_skip_relocation, ventura:       "4ba551506a2ceeffe536f958f9437178dee3dfbbb40593d4923449dcd60e48f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4cbf68ee1cac66980a9c59042149e18962499b2ecc886fadd6ffabaccfe7341a"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    (testpath"broken.py").write <<~EOS
      def wrong_types(a: int, b: int) -> str:
          return a + b
    EOS
    output = pipe_output("#{bin}pyright broken.py 2>&1")
    assert_match "error: Type \"int\" is not assignable to return type \"str\"", output
  end
end