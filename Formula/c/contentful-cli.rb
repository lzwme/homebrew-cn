require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-3.1.21.tgz"
  sha256 "c79bfe1f0dcc29f8c6e1645a15f103e6a132edc75e773d46417eca71f4e653a5"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ee0bff7e6c0b41407918725dc3f34aef5e12798ff7e057e1396897882983ce54"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ee0bff7e6c0b41407918725dc3f34aef5e12798ff7e057e1396897882983ce54"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ee0bff7e6c0b41407918725dc3f34aef5e12798ff7e057e1396897882983ce54"
    sha256 cellar: :any_skip_relocation, sonoma:         "88d03e1996d5b90c07ee3ade0a46c869c5ecb656a1e202870d6927127c4a20b4"
    sha256 cellar: :any_skip_relocation, ventura:        "88d03e1996d5b90c07ee3ade0a46c869c5ecb656a1e202870d6927127c4a20b4"
    sha256 cellar: :any_skip_relocation, monterey:       "88d03e1996d5b90c07ee3ade0a46c869c5ecb656a1e202870d6927127c4a20b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee0bff7e6c0b41407918725dc3f34aef5e12798ff7e057e1396897882983ce54"
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