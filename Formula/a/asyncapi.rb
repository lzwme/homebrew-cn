require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-1.2.0.tgz"
  sha256 "20cdfb5c9ddb65d43e1fd4b65aaf67058816b14f9a8619f204ee3a7fc07e9e8f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2b5f02f43679d33f3d58fff983236a693ea733fa2c283c69d300bf6547b6dbd3"
    sha256 cellar: :any,                 arm64_ventura:  "2b5f02f43679d33f3d58fff983236a693ea733fa2c283c69d300bf6547b6dbd3"
    sha256 cellar: :any,                 arm64_monterey: "2b5f02f43679d33f3d58fff983236a693ea733fa2c283c69d300bf6547b6dbd3"
    sha256 cellar: :any,                 sonoma:         "e9fc17ce693b98dcbbee424f3a8822b321a47a02203834c0db451763119b38aa"
    sha256 cellar: :any,                 ventura:        "e9fc17ce693b98dcbbee424f3a8822b321a47a02203834c0db451763119b38aa"
    sha256 cellar: :any,                 monterey:       "e9fc17ce693b98dcbbee424f3a8822b321a47a02203834c0db451763119b38aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f17cadfaaa741564c15949e75ffc034e1a3e14e8563b6407422bc4966ed7cb1a"
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