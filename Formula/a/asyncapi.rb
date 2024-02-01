require "languagenode"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https:github.comasyncapicli"
  url "https:registry.npmjs.org@asyncapicli-cli-1.4.12.tgz"
  sha256 "f404c6017ca415172b890907a5a2a741d939efe06fd059864a8489e0bcd7a9cd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "502eb310e182884e32f7b1e9525c94848e858fa4bd31adecbe90830c9bd738cb"
    sha256 cellar: :any,                 arm64_ventura:  "502eb310e182884e32f7b1e9525c94848e858fa4bd31adecbe90830c9bd738cb"
    sha256 cellar: :any,                 arm64_monterey: "502eb310e182884e32f7b1e9525c94848e858fa4bd31adecbe90830c9bd738cb"
    sha256 cellar: :any,                 sonoma:         "3c5feb6a67151d667cfd39fbe781fea6b5b6de7e124d84d02c246eeffe2a49ee"
    sha256 cellar: :any,                 ventura:        "3c5feb6a67151d667cfd39fbe781fea6b5b6de7e124d84d02c246eeffe2a49ee"
    sha256 cellar: :any,                 monterey:       "3c5feb6a67151d667cfd39fbe781fea6b5b6de7e124d84d02c246eeffe2a49ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b3039b47eecc79c8b05d05ade00c9593f957ee5d270dc461c18ca30afc88322e"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}bin*"]

    # Delete native binaries installed by npm, as we dont support `musl` for a `libc` implementation
    node_modules = libexec"libnode_modules@asyncapiclinode_modules"
    (node_modules"@swccore-linux-x64-muslswc.linux-x64-musl.node").unlink if OS.linux?

    # Replace universal binaries with their native slices
    deuniversalize_machos
  end

  test do
    system bin"asyncapi", "new", "--file-name=asyncapi.yml", "--example=default-example.yaml", "--no-tty"
    assert_predicate testpath"asyncapi.yml", :exist?, "AsyncAPI file was not created"
  end
end