class Prettier < Formula
  desc "Code formatter for JavaScript, CSS, JSON, GraphQL, Markdown, YAML"
  homepage "https:prettier.io"
  url "https:registry.npmjs.orgprettier-prettier-3.6.2.tgz"
  sha256 "bc81ab83674f175a8601b7d013786f48ec2507dd4a5fcf3415831ff13a875bdf"
  license "MIT"
  head "https:github.comprettierprettier.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2a7d562b5ef51fbc4126e9b8589bacbc05413f7e40f59c86244a08d117f48aed"
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