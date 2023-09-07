require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.54.6.tgz"
  sha256 "fc28ec92405bee77abe6e43c66a16cbbb94ddc488027c413797564824870724c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "2fac74a50e09d1427e5c06d04cf248931176fb29b9d4c824201bfa8936301f5f"
    sha256 cellar: :any,                 arm64_monterey: "2fac74a50e09d1427e5c06d04cf248931176fb29b9d4c824201bfa8936301f5f"
    sha256 cellar: :any,                 arm64_big_sur:  "2fac74a50e09d1427e5c06d04cf248931176fb29b9d4c824201bfa8936301f5f"
    sha256 cellar: :any,                 ventura:        "d67d05bb2ce11752f368d1140c13dc5e6178a734111690c3db86740b85f5af2a"
    sha256 cellar: :any,                 monterey:       "d67d05bb2ce11752f368d1140c13dc5e6178a734111690c3db86740b85f5af2a"
    sha256 cellar: :any,                 big_sur:        "d67d05bb2ce11752f368d1140c13dc5e6178a734111690c3db86740b85f5af2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "08b1c1c7fa0a87021f3ca2dd4445744b0a2b40b9fefb81c334f574f9999c9512"
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