require "language/node"

class Prettier < Formula
  desc "Code formatter for JavaScript, CSS, JSON, GraphQL, Markdown, YAML"
  homepage "https://prettier.io/"
  url "https://registry.npmjs.org/prettier/-/prettier-3.0.1.tgz"
  sha256 "5b75344a01d2728ddf269ccf70c37c823aec01440b30a28e33d17068eec87eaa"
  license "MIT"
  head "https://github.com/prettier/prettier.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bc45d31a6b0a8cf96cae3f59ab037ef52df38babb8d10f8d2b4922126aac5f99"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bc45d31a6b0a8cf96cae3f59ab037ef52df38babb8d10f8d2b4922126aac5f99"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bc45d31a6b0a8cf96cae3f59ab037ef52df38babb8d10f8d2b4922126aac5f99"
    sha256 cellar: :any_skip_relocation, ventura:        "bc45d31a6b0a8cf96cae3f59ab037ef52df38babb8d10f8d2b4922126aac5f99"
    sha256 cellar: :any_skip_relocation, monterey:       "bc45d31a6b0a8cf96cae3f59ab037ef52df38babb8d10f8d2b4922126aac5f99"
    sha256 cellar: :any_skip_relocation, big_sur:        "bc45d31a6b0a8cf96cae3f59ab037ef52df38babb8d10f8d2b4922126aac5f99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a7295921acc4f0b4fdb4b559ab9e2be6c1d5da5d8e85c5444f9e880f9d3dc553"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.js").write("const arr = [1,2];")
    output = shell_output("#{bin}/prettier test.js")
    assert_equal "const arr = [1, 2];", output.chomp
  end
end