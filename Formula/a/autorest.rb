require "language/node"

class Autorest < Formula
  desc "Swagger (OpenAPI) Specification code generator"
  homepage "https://github.com/Azure/autorest"
  url "https://registry.npmjs.org/autorest/-/autorest-3.7.0.tgz"
  sha256 "276671b8c39498a1559da57131e198a0b6e655c8ca1a3a6667835dd3dfef5869"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cb8ad4ebd74982b3e80875b05b2a58e57c13f21ce3980a89df3edce36c70a1a9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cb8ad4ebd74982b3e80875b05b2a58e57c13f21ce3980a89df3edce36c70a1a9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cb8ad4ebd74982b3e80875b05b2a58e57c13f21ce3980a89df3edce36c70a1a9"
    sha256 cellar: :any_skip_relocation, sonoma:         "7dcb2d85d8a7d95e1a98f0aa31f7fc5378150f2e631873faec8203407e33580a"
    sha256 cellar: :any_skip_relocation, ventura:        "7dcb2d85d8a7d95e1a98f0aa31f7fc5378150f2e631873faec8203407e33580a"
    sha256 cellar: :any_skip_relocation, monterey:       "7dcb2d85d8a7d95e1a98f0aa31f7fc5378150f2e631873faec8203407e33580a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cb8ad4ebd74982b3e80875b05b2a58e57c13f21ce3980a89df3edce36c70a1a9"
  end

  depends_on "node"

  resource "homebrew-petstore" do
    url "https://ghproxy.com/https://raw.githubusercontent.com/Azure/autorest/5c170a02c009d032e10aa9f5ab7841e637b3d53b/Samples/1b-code-generation-multilang/petstore.yaml"
    sha256 "e981f21115bc9deba47c74e5c533d92a94cf5dbe880c4304357650083283ce13"
  end

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    resource("homebrew-petstore").stage do
      system (bin/"autorest"), "--input-file=petstore.yaml",
                               "--typescript",
                               "--output-folder=petstore"
      assert_includes File.read("petstore/package.json"), "Microsoft Corporation"
    end
  end
end