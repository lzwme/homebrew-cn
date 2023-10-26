require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-3.1.0.tgz"
  sha256 "5eecd9f9a0a6c4d95ad205a0d99fa931997a7d752a73a876655429a5f80af636"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f0f2c7422780c96e1cafcac82e8a8629bcd02d4221b02c11aee2676916fe9590"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f0f2c7422780c96e1cafcac82e8a8629bcd02d4221b02c11aee2676916fe9590"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f0f2c7422780c96e1cafcac82e8a8629bcd02d4221b02c11aee2676916fe9590"
    sha256 cellar: :any_skip_relocation, sonoma:         "2aad3cbd8e5eedc0431ade912e53aaef7f779117c657f0519c488a2b2f80ca18"
    sha256 cellar: :any_skip_relocation, ventura:        "2aad3cbd8e5eedc0431ade912e53aaef7f779117c657f0519c488a2b2f80ca18"
    sha256 cellar: :any_skip_relocation, monterey:       "2aad3cbd8e5eedc0431ade912e53aaef7f779117c657f0519c488a2b2f80ca18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f0f2c7422780c96e1cafcac82e8a8629bcd02d4221b02c11aee2676916fe9590"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/contentful space list 2>&1", 1)
    assert_match "🚨  Error: You have to be logged in to do this.", output
    assert_match "You can log in via contentful login", output
    assert_match "Or provide a management token via --management-token argument", output
  end
end