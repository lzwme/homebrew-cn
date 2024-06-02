require "languagenode"

class Prettier < Formula
  desc "Code formatter for JavaScript, CSS, JSON, GraphQL, Markdown, YAML"
  homepage "https:prettier.io"
  url "https:registry.npmjs.orgprettier-prettier-3.3.0.tgz"
  sha256 "4b2b347100ba4f9fbf35df3295ba3cf3438d9f967b267c1aa8e2c943f8ee1c0d"
  license "MIT"
  head "https:github.comprettierprettier.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "33c81840f9c28c88666b44c22eef14416c41871041c79b9eb369add35b857614"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "33c81840f9c28c88666b44c22eef14416c41871041c79b9eb369add35b857614"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "33c81840f9c28c88666b44c22eef14416c41871041c79b9eb369add35b857614"
    sha256 cellar: :any_skip_relocation, sonoma:         "33c81840f9c28c88666b44c22eef14416c41871041c79b9eb369add35b857614"
    sha256 cellar: :any_skip_relocation, ventura:        "33c81840f9c28c88666b44c22eef14416c41871041c79b9eb369add35b857614"
    sha256 cellar: :any_skip_relocation, monterey:       "33c81840f9c28c88666b44c22eef14416c41871041c79b9eb369add35b857614"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1b0cdaffdc7bd1af6150b504029a5827e7d71c132d09601abf0253569b0d10f9"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    (testpath"test.js").write("const arr = [1,2];")
    output = shell_output("#{bin}prettier test.js")
    assert_equal "const arr = [1, 2];", output.chomp
  end
end