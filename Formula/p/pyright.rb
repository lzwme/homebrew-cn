require "languagenode"

class Pyright < Formula
  desc "Static type checker for Python"
  homepage "https:github.commicrosoftpyright"
  url "https:registry.npmjs.orgpyright-pyright-1.1.359.tgz"
  sha256 "48875272e10c3023e2ca069fba2de90bbb296b4500dafc33262eb40b5bd80d2c"
  license "MIT"
  head "https:github.commicrosoftpyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f28f6f87ef7ce0269f051cb35fa92868065132f9feb4b9bdeb7fd6115cb3eb34"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f28f6f87ef7ce0269f051cb35fa92868065132f9feb4b9bdeb7fd6115cb3eb34"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f28f6f87ef7ce0269f051cb35fa92868065132f9feb4b9bdeb7fd6115cb3eb34"
    sha256 cellar: :any_skip_relocation, sonoma:         "453fab93972151fc6653e9b735dde550ccb8c9aaeb9b47d32d1f82907c940f52"
    sha256 cellar: :any_skip_relocation, ventura:        "453fab93972151fc6653e9b735dde550ccb8c9aaeb9b47d32d1f82907c940f52"
    sha256 cellar: :any_skip_relocation, monterey:       "453fab93972151fc6653e9b735dde550ccb8c9aaeb9b47d32d1f82907c940f52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f28f6f87ef7ce0269f051cb35fa92868065132f9feb4b9bdeb7fd6115cb3eb34"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    (testpath"broken.py").write <<~EOS
      def wrong_types(a: int, b: int) -> str:
          return a + b
    EOS
    output = pipe_output("#{bin}pyright broken.py 2>&1")
    assert_match "error: Expression of type \"int\" is incompatible with return type \"str\"", output
  end
end