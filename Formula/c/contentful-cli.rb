require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-3.0.11.tgz"
  sha256 "bc5c38259005757ae1b3b5133689ea298c5e355e74f0496911800a297676e725"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "98199e83a7cf3af456c088ea8e4d89e7f3669f2346c85d024383c874118c66e5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "98199e83a7cf3af456c088ea8e4d89e7f3669f2346c85d024383c874118c66e5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "98199e83a7cf3af456c088ea8e4d89e7f3669f2346c85d024383c874118c66e5"
    sha256 cellar: :any_skip_relocation, sonoma:         "435d83b0408ecc3f3036859ad4b21ef26fc7bd3a133830ca2848e3265facc071"
    sha256 cellar: :any_skip_relocation, ventura:        "435d83b0408ecc3f3036859ad4b21ef26fc7bd3a133830ca2848e3265facc071"
    sha256 cellar: :any_skip_relocation, monterey:       "d0fd39ae30bbc638bda5f80ba7e13fdc94d9585ace4b896170162811b211abc2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "98199e83a7cf3af456c088ea8e4d89e7f3669f2346c85d024383c874118c66e5"
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