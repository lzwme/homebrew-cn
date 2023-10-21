require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-3.0.6.tgz"
  sha256 "88ed5ca18ac69a9c4d469efdac40520c9f2870141edf8e9b9d702dffcb89d948"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "92f8b8b109b9df6acf41aa3f1f21beb46ecd3d3ba42a53d45fda15251016a1bd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "92f8b8b109b9df6acf41aa3f1f21beb46ecd3d3ba42a53d45fda15251016a1bd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "92f8b8b109b9df6acf41aa3f1f21beb46ecd3d3ba42a53d45fda15251016a1bd"
    sha256 cellar: :any_skip_relocation, sonoma:         "629009bc6e6edddff91c9821f6ccfc0293f9ab13fdde548eb9c91faed9bac0e0"
    sha256 cellar: :any_skip_relocation, ventura:        "629009bc6e6edddff91c9821f6ccfc0293f9ab13fdde548eb9c91faed9bac0e0"
    sha256 cellar: :any_skip_relocation, monterey:       "629009bc6e6edddff91c9821f6ccfc0293f9ab13fdde548eb9c91faed9bac0e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "92f8b8b109b9df6acf41aa3f1f21beb46ecd3d3ba42a53d45fda15251016a1bd"
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