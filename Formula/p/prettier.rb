class Prettier < Formula
  desc "Code formatter for JavaScript, CSS, JSON, GraphQL, Markdown, YAML"
  homepage "https:prettier.io"
  url "https:registry.npmjs.orgprettier-prettier-3.6.0.tgz"
  sha256 "beef60291daec2fb569e300117ae380d3dba81cd248496ac66e50042b8686c31"
  license "MIT"
  head "https:github.comprettierprettier.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5399d3e5e5aa3206987f586a2dd24f5126ae693a964a4b4dbed8dbb7f62a9875"
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