class Prettier < Formula
  desc "Code formatter for JavaScript, CSS, JSON, GraphQL, Markdown, YAML"
  homepage "https:prettier.io"
  url "https:registry.npmjs.orgprettier-prettier-3.5.1.tgz"
  sha256 "6045af17c434fdfb0354fc4c0d1f9714adc379f6c9595729290c6bd1b51e33f3"
  license "MIT"
  head "https:github.comprettierprettier.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e8245b98a8828d904bbb5754fb76b45ee36e1edc04c89ef0ccca265d03d346ff"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    (testpath"test.js").write("const arr = [1,2];")
    output = shell_output("#{bin}prettier test.js")
    assert_equal "const arr = [1, 2];", output.chomp
  end
end