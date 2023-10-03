require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.58.2.tgz"
  sha256 "c99691aedc06a6e62e916b17c0f6e2e8b77bbb0b71ab08389fbd1319b7ba065b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d7c4bb3f76fa416f5f65316066bfa82f2f79a21c0647d4bf7445cc96493a7609"
    sha256 cellar: :any,                 arm64_ventura:  "d7c4bb3f76fa416f5f65316066bfa82f2f79a21c0647d4bf7445cc96493a7609"
    sha256 cellar: :any,                 arm64_monterey: "d7c4bb3f76fa416f5f65316066bfa82f2f79a21c0647d4bf7445cc96493a7609"
    sha256 cellar: :any,                 sonoma:         "07638e33ab74bc73a8ba57295f1159222a1cabb5d9d106c3b66a2106173d528b"
    sha256 cellar: :any,                 ventura:        "07638e33ab74bc73a8ba57295f1159222a1cabb5d9d106c3b66a2106173d528b"
    sha256 cellar: :any,                 monterey:       "da19863134c74922509802b301745ce8780f78e0a558756de06374eebd289ba4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a80964987cce79f69c98ad61c22208df8d47ef3ac5902c2f46716e8543235ea6"
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