require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.60.0.tgz"
  sha256 "bf7d51c2fd76f14252302d7671c787bd6951f0c12c45699652f1d3688a4071cb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "5a7de443241c5f9f5129111aa4cd692c548afdbefafd998ffacfbb301b4b1860"
    sha256 cellar: :any,                 arm64_ventura:  "5a7de443241c5f9f5129111aa4cd692c548afdbefafd998ffacfbb301b4b1860"
    sha256 cellar: :any,                 arm64_monterey: "5a7de443241c5f9f5129111aa4cd692c548afdbefafd998ffacfbb301b4b1860"
    sha256 cellar: :any,                 sonoma:         "1351c5420e4291c6d2260144f199025773087796e20dae096ac0a9d5dd71c8ea"
    sha256 cellar: :any,                 ventura:        "1351c5420e4291c6d2260144f199025773087796e20dae096ac0a9d5dd71c8ea"
    sha256 cellar: :any,                 monterey:       "1351c5420e4291c6d2260144f199025773087796e20dae096ac0a9d5dd71c8ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e043772431ddc752ad3a120c7385c44089824c75ecfa29791fafd2760c37b47a"
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