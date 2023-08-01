require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.51.5.tgz"
  sha256 "28fbe951b20a2cb24500acf2b1472006d89e4a758dbd05c2656bc74d32fe5695"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "5b4bd99b821ffcf622c56ccd26e50128b3b87c34cdc9274d9bccacfaaa062bc1"
    sha256 cellar: :any,                 arm64_monterey: "5b4bd99b821ffcf622c56ccd26e50128b3b87c34cdc9274d9bccacfaaa062bc1"
    sha256 cellar: :any,                 arm64_big_sur:  "5b4bd99b821ffcf622c56ccd26e50128b3b87c34cdc9274d9bccacfaaa062bc1"
    sha256 cellar: :any,                 ventura:        "2446a64d1f58e1c963bfc9413542cc5fd50ff0c88732fccfee2662b142229a9f"
    sha256 cellar: :any,                 monterey:       "2446a64d1f58e1c963bfc9413542cc5fd50ff0c88732fccfee2662b142229a9f"
    sha256 cellar: :any,                 big_sur:        "2446a64d1f58e1c963bfc9413542cc5fd50ff0c88732fccfee2662b142229a9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "931615c644d7a18d5d257c97ee87728655b50105d18567f90310e137ba5fe9d3"
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