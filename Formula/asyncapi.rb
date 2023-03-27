require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.33.1.tgz"
  sha256 "69a99830a0553bbea387f375ecfe79a4e4121e5b965fd9644bf94ea9247e401d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "828d634bf694bb09b98352c19d2ae5e7ed624c7ddc2949503f23140154e5beef"
    sha256 cellar: :any,                 arm64_monterey: "828d634bf694bb09b98352c19d2ae5e7ed624c7ddc2949503f23140154e5beef"
    sha256 cellar: :any,                 arm64_big_sur:  "828d634bf694bb09b98352c19d2ae5e7ed624c7ddc2949503f23140154e5beef"
    sha256 cellar: :any,                 ventura:        "ec538ec0e45d040b00dc8b734b15848cc65ff2e0d65211370218a1f71ca217cc"
    sha256 cellar: :any,                 monterey:       "ec538ec0e45d040b00dc8b734b15848cc65ff2e0d65211370218a1f71ca217cc"
    sha256 cellar: :any,                 big_sur:        "ec538ec0e45d040b00dc8b734b15848cc65ff2e0d65211370218a1f71ca217cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1148476ec34969ceda9122e8e6d2630cbb3f480663487087c30b34e40dc74b3d"
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