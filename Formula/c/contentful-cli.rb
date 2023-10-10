require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-3.0.1.tgz"
  sha256 "517a1f4131404f37962d497b97bd951c55f4a408ef5cb9e6f120696585fdbc42"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fc80ee4283363bfce95f2780075d77ad5875dea5aa80a429c5f543b7f52a45f8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fc80ee4283363bfce95f2780075d77ad5875dea5aa80a429c5f543b7f52a45f8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fc80ee4283363bfce95f2780075d77ad5875dea5aa80a429c5f543b7f52a45f8"
    sha256 cellar: :any_skip_relocation, sonoma:         "d83a9344f2ebada46b0dd7db85de9c608ddcb4f8186dabeb81b35ced61df8252"
    sha256 cellar: :any_skip_relocation, ventura:        "d83a9344f2ebada46b0dd7db85de9c608ddcb4f8186dabeb81b35ced61df8252"
    sha256 cellar: :any_skip_relocation, monterey:       "bd43aae4d1cfb2ef4bbb22810410c7a749d36a1eec5ced4a20d9e2bdd62067e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fc80ee4283363bfce95f2780075d77ad5875dea5aa80a429c5f543b7f52a45f8"
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