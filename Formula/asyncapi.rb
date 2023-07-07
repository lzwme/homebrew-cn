require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.50.2.tgz"
  sha256 "0c65cb9a4d258c97da1115ab4eca17f6f391d528c656f2e804116c64239212be"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "234fd453c34bf6c4f2ef3101a9e49e685a8c3684d35b9206d337169177dc625a"
    sha256 cellar: :any,                 arm64_monterey: "234fd453c34bf6c4f2ef3101a9e49e685a8c3684d35b9206d337169177dc625a"
    sha256 cellar: :any,                 arm64_big_sur:  "234fd453c34bf6c4f2ef3101a9e49e685a8c3684d35b9206d337169177dc625a"
    sha256 cellar: :any,                 ventura:        "3817fed3485945f4e469bd7f11962c1abc838260faa92cdce5d45e3174488d05"
    sha256 cellar: :any,                 monterey:       "3817fed3485945f4e469bd7f11962c1abc838260faa92cdce5d45e3174488d05"
    sha256 cellar: :any,                 big_sur:        "3817fed3485945f4e469bd7f11962c1abc838260faa92cdce5d45e3174488d05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c6043e7a35327f7b8411dd2f6dc1cd30c77c90198faf3465fbd306bb5787f6a9"
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