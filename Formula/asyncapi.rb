require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.45.0.tgz"
  sha256 "3b1e62b1874811bdac0859a4b7c386452e95cd6e5405ab08c8a68db47f125c99"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "12777d4e54932b785cd1f3b56062d6a00f990efd10c6e91d8dc03324912607bb"
    sha256 cellar: :any,                 arm64_monterey: "12777d4e54932b785cd1f3b56062d6a00f990efd10c6e91d8dc03324912607bb"
    sha256 cellar: :any,                 arm64_big_sur:  "12777d4e54932b785cd1f3b56062d6a00f990efd10c6e91d8dc03324912607bb"
    sha256 cellar: :any,                 ventura:        "60d2fbe111e58d7bf7b18225ed56fa270fb63aae73d020e3eab6ddb7f9dd7826"
    sha256 cellar: :any,                 monterey:       "60d2fbe111e58d7bf7b18225ed56fa270fb63aae73d020e3eab6ddb7f9dd7826"
    sha256 cellar: :any,                 big_sur:        "60d2fbe111e58d7bf7b18225ed56fa270fb63aae73d020e3eab6ddb7f9dd7826"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4ee6cc30353c0af7f54fe4e35165b6b9cb94286c74c968f8edac7c03b921a954"
  end

  depends_on "node"

  def install
    # Call rm -f instead of rimraf, because devDeps aren't present in Homebrew at postpack time
    inreplace "package.json", "rimraf oclif.manifest.json", "rm -f oclif.manifest.json"
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Delete native binaries installed by npm, as we dont support `musl` for a `libc` implementation
    node_modules = libexec/"lib/node_modules/@asyncapi/cli/node_modules"
    (node_modules/"@swc/core-linux-x64-musl/swc.linux-x64-musl.node").unlink if OS.linux?

    # Replace universal binaries with their native slices
    deuniversalize_machos
  end

  test do
    system bin/"asyncapi", "new", "--file-name=asyncapi.yml", "--example=default-example.yaml", "--no-tty"
    assert_predicate testpath/"asyncapi.yml", :exist?, "AsyncAPI file was not created"
  end
end