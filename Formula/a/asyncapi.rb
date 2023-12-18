require "languagenode"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https:github.comasyncapicli"
  url "https:registry.npmjs.org@asyncapicli-cli-1.2.23.tgz"
  sha256 "93e8781a6915e093ec2846f8fc032df2d3ac0c103bf78982566947af4dae0e47"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "917481077cb501fb2bdaddf949affd261a5d04c15a34d0a85b401b0feedf1b2b"
    sha256 cellar: :any,                 arm64_ventura:  "917481077cb501fb2bdaddf949affd261a5d04c15a34d0a85b401b0feedf1b2b"
    sha256 cellar: :any,                 arm64_monterey: "917481077cb501fb2bdaddf949affd261a5d04c15a34d0a85b401b0feedf1b2b"
    sha256 cellar: :any,                 sonoma:         "e2387286eaec06886e67eb54fab1e09343a6ae36d5971b0d22a0a0c83a7ada14"
    sha256 cellar: :any,                 ventura:        "e2387286eaec06886e67eb54fab1e09343a6ae36d5971b0d22a0a0c83a7ada14"
    sha256 cellar: :any,                 monterey:       "e2387286eaec06886e67eb54fab1e09343a6ae36d5971b0d22a0a0c83a7ada14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d5b2a19995c8189c53eb59a158d1106c0d2d0f402ce0f8c6aa9d6d51afb48be"
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