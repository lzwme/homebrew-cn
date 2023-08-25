require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.54.2.tgz"
  sha256 "77391b491886bbc5263359458b037431e2e7f62d2fd23a3fbe2ee2b741b107a5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "0a7629e00ba02c95833922abc6a870bee8ca0738bd83d45eebce0df5af167e4c"
    sha256 cellar: :any,                 arm64_monterey: "0a7629e00ba02c95833922abc6a870bee8ca0738bd83d45eebce0df5af167e4c"
    sha256 cellar: :any,                 arm64_big_sur:  "0a7629e00ba02c95833922abc6a870bee8ca0738bd83d45eebce0df5af167e4c"
    sha256 cellar: :any,                 ventura:        "0bbb0ba4d482763825b902bd3699d9a2a3dc5e308b5af02faeec0a700e3890d1"
    sha256 cellar: :any,                 monterey:       "0bbb0ba4d482763825b902bd3699d9a2a3dc5e308b5af02faeec0a700e3890d1"
    sha256 cellar: :any,                 big_sur:        "0bbb0ba4d482763825b902bd3699d9a2a3dc5e308b5af02faeec0a700e3890d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ce054a900c5d69a9ae86c7e617770aa5b760282af0d6a04fa60d04d983f90233"
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