require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.58.9.tgz"
  sha256 "922e4dbb19b9c802b2dfbc77e3c600d965b5d4ef2e927f3f64ed92529ce939f1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "026f4ed867cad5f012bc8cf7fb05a1373a73ca525ac416cad5538749f608505e"
    sha256 cellar: :any,                 arm64_ventura:  "026f4ed867cad5f012bc8cf7fb05a1373a73ca525ac416cad5538749f608505e"
    sha256 cellar: :any,                 arm64_monterey: "026f4ed867cad5f012bc8cf7fb05a1373a73ca525ac416cad5538749f608505e"
    sha256 cellar: :any,                 sonoma:         "8c8773ce2b55957bf25a5c48543f2318910a4c369f11a33bfaff69d4c3aed031"
    sha256 cellar: :any,                 ventura:        "8c8773ce2b55957bf25a5c48543f2318910a4c369f11a33bfaff69d4c3aed031"
    sha256 cellar: :any,                 monterey:       "8c8773ce2b55957bf25a5c48543f2318910a4c369f11a33bfaff69d4c3aed031"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5a4a8f586604295d8c3d25cea6a2466310e48f518e0f25869e082e0910d6b095"
  end

  depends_on "node"

  def install
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