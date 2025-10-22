class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-3.9.5.tgz"
  sha256 "0f1afeb0594c5e9101a77ac0a0344231d2734da3fe64e262cac242a4d4954312"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5368ccac7b13c21058bbae3cc22619b1846a2e0196f89070977b3db5ef936ff8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5368ccac7b13c21058bbae3cc22619b1846a2e0196f89070977b3db5ef936ff8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5368ccac7b13c21058bbae3cc22619b1846a2e0196f89070977b3db5ef936ff8"
    sha256 cellar: :any_skip_relocation, sonoma:        "5368ccac7b13c21058bbae3cc22619b1846a2e0196f89070977b3db5ef936ff8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5368ccac7b13c21058bbae3cc22619b1846a2e0196f89070977b3db5ef936ff8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "258d734090bbeb3c9a4d8d123ac0228b8c9c28d56aa9274bffe0e7805f292452"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/contentful space list 2>&1", 1)
    assert_match "🚨  Error: You have to be logged in to do this.", output
    assert_match "You can log in via contentful login", output
    assert_match "Or provide a management token via --management-token argument", output
  end
end