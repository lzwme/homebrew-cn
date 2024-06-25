require "languagenode"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https:github.comcontentfulcontentful-cli"
  url "https:registry.npmjs.orgcontentful-cli-contentful-cli-3.3.3.tgz"
  sha256 "d3e5b17de843d7230babb6f6604c3aa4c6d5acff627b934a8eb3ae302ae80b4f"
  license "MIT"
  head "https:github.comcontentfulcontentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a0df0be8cf868331c49d56dfc7abb5a4addff00fcae0e2360b8015611cda58d6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a0df0be8cf868331c49d56dfc7abb5a4addff00fcae0e2360b8015611cda58d6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a0df0be8cf868331c49d56dfc7abb5a4addff00fcae0e2360b8015611cda58d6"
    sha256 cellar: :any_skip_relocation, sonoma:         "c4952a10b381a4352212247893f8c32b8a26842df875a12792f666f6e8557cd3"
    sha256 cellar: :any_skip_relocation, ventura:        "c4952a10b381a4352212247893f8c32b8a26842df875a12792f666f6e8557cd3"
    sha256 cellar: :any_skip_relocation, monterey:       "c4952a10b381a4352212247893f8c32b8a26842df875a12792f666f6e8557cd3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "70109e3187f2db0f0753ac9fa52aec12948b842544391ac8dec4cec4b88f629c"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    output = shell_output("#{bin}contentful space list 2>&1", 1)
    assert_match "🚨  Error: You have to be logged in to do this.", output
    assert_match "You can log in via contentful login", output
    assert_match "Or provide a management token via --management-token argument", output
  end
end