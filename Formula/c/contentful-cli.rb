class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https:github.comcontentfulcontentful-cli"
  url "https:registry.npmjs.orgcontentful-cli-contentful-cli-3.5.5.tgz"
  sha256 "cf78ac0bcdb2838e6d93236f764e5e7f5416455d75e63d7385e8e472ac2e4f04"
  license "MIT"
  head "https:github.comcontentfulcontentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "379808a6a443e622b70430d99e86b4b6ddbf4a3d444ce474b0a6285042543204"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "379808a6a443e622b70430d99e86b4b6ddbf4a3d444ce474b0a6285042543204"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "379808a6a443e622b70430d99e86b4b6ddbf4a3d444ce474b0a6285042543204"
    sha256 cellar: :any_skip_relocation, sonoma:        "2b04e6ff56961497324dea8ec5b1b62d7d5caa240a7df2f705b79fb22d18878b"
    sha256 cellar: :any_skip_relocation, ventura:       "2b04e6ff56961497324dea8ec5b1b62d7d5caa240a7df2f705b79fb22d18878b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "379808a6a443e622b70430d99e86b4b6ddbf4a3d444ce474b0a6285042543204"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    output = shell_output("#{bin}contentful space list 2>&1", 1)
    assert_match "🚨  Error: You have to be logged in to do this.", output
    assert_match "You can log in via contentful login", output
    assert_match "Or provide a management token via --management-token argument", output
  end
end