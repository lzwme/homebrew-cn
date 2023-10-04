require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.58.3.tgz"
  sha256 "3c7b57e25c6dfb0099e599d1c3f9edfb15eef00f751862e8a22297c22910ff03"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "cca020e8a32b067203491e8a07759cd04fba6d74cfe467519a310b14841e6140"
    sha256 cellar: :any,                 arm64_ventura:  "cca020e8a32b067203491e8a07759cd04fba6d74cfe467519a310b14841e6140"
    sha256 cellar: :any,                 arm64_monterey: "cca020e8a32b067203491e8a07759cd04fba6d74cfe467519a310b14841e6140"
    sha256 cellar: :any,                 sonoma:         "fba8f345af5f45362ac03d2027600e69507af2a5536514ec0209250512cf3dde"
    sha256 cellar: :any,                 ventura:        "fba8f345af5f45362ac03d2027600e69507af2a5536514ec0209250512cf3dde"
    sha256 cellar: :any,                 monterey:       "e36d5639b3107c570a63afc011545f90e844653794a2e3ea48a755515e232526"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8af3c2e98bc0f402112fe79b96bebd20f9d93b5a1d601553548ccf4f9571699f"
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