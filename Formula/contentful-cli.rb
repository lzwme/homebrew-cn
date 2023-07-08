require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-2.6.28.tgz"
  sha256 "5a0cf88c45f0846ca6d749dfb7d57d8b74c60f22daa814927d33b96212a81654"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2fb18c013b9d2c2418622da4b7ba8560c05b33a6c8499783e90597e74f6cb6e9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2fb18c013b9d2c2418622da4b7ba8560c05b33a6c8499783e90597e74f6cb6e9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2fb18c013b9d2c2418622da4b7ba8560c05b33a6c8499783e90597e74f6cb6e9"
    sha256 cellar: :any_skip_relocation, ventura:        "ac30a6a9995675283140fc758a0cebacdc468998253858b913a50297b1d223bf"
    sha256 cellar: :any_skip_relocation, monterey:       "ac30a6a9995675283140fc758a0cebacdc468998253858b913a50297b1d223bf"
    sha256 cellar: :any_skip_relocation, big_sur:        "ac30a6a9995675283140fc758a0cebacdc468998253858b913a50297b1d223bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2fb18c013b9d2c2418622da4b7ba8560c05b33a6c8499783e90597e74f6cb6e9"
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