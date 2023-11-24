require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-3.1.17.tgz"
  sha256 "1a888af3204370b32954773959fcecce0caa5e75c47937ff44b8d3469ff11b60"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e50ecfbe7c59ecf612d79297b1d3511743bc6a60b3bd2572a537a0ffe9285d5b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e50ecfbe7c59ecf612d79297b1d3511743bc6a60b3bd2572a537a0ffe9285d5b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e50ecfbe7c59ecf612d79297b1d3511743bc6a60b3bd2572a537a0ffe9285d5b"
    sha256 cellar: :any_skip_relocation, sonoma:         "fbe076f6391b0f6fa01a2828ce08c8b92dfac9924e77af6ea4c86f9236441e47"
    sha256 cellar: :any_skip_relocation, ventura:        "fbe076f6391b0f6fa01a2828ce08c8b92dfac9924e77af6ea4c86f9236441e47"
    sha256 cellar: :any_skip_relocation, monterey:       "fbe076f6391b0f6fa01a2828ce08c8b92dfac9924e77af6ea4c86f9236441e47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e50ecfbe7c59ecf612d79297b1d3511743bc6a60b3bd2572a537a0ffe9285d5b"
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