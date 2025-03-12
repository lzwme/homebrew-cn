class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https:github.comasyncapicli"
  url "https:registry.npmjs.org@asyncapicli-cli-2.16.8.tgz"
  sha256 "6e70d5dfe0edf4726e869ed42ae59047fc958517001d41af32f7dcc088e8ddfa"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "dfa8bdd6db5e1a13dbdf3b9c6bf5db2e3ebd07aaef5e9d9bcf4264dcdfdf0b6f"
    sha256 cellar: :any,                 arm64_sonoma:  "dfa8bdd6db5e1a13dbdf3b9c6bf5db2e3ebd07aaef5e9d9bcf4264dcdfdf0b6f"
    sha256 cellar: :any,                 arm64_ventura: "dfa8bdd6db5e1a13dbdf3b9c6bf5db2e3ebd07aaef5e9d9bcf4264dcdfdf0b6f"
    sha256 cellar: :any,                 sonoma:        "30d8d0b2e3e5a13a813610678d60b31028910ef64c03e853dbb771c74796ade7"
    sha256 cellar: :any,                 ventura:       "30d8d0b2e3e5a13a813610678d60b31028910ef64c03e853dbb771c74796ade7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f92e697b3413265a6c327a646bdcb673a2b43be056c46358bf206b941834730"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]

    # Cleanup .pnpm folder
    node_modules = libexec"libnode_modules@asyncapiclinode_modules"
    rm_r (node_modules"@asyncapistudiobuildstandalonenode_modules.pnpm") if OS.linux?
  end

  test do
    system bin"asyncapi", "new", "file", "--file-name=asyncapi.yml", "--example=default-example.yaml", "--no-tty"
    assert_path_exists testpath"asyncapi.yml", "AsyncAPI file was not created"
  end
end