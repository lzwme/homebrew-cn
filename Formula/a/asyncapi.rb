require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.52.5.tgz"
  sha256 "cd3f79dc5a260aff1284a9418352f83368908c6a4f92c81bbe01c4718f5549de"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "76eab44501da3c25d487810decd0fcf1eaf3cf9a86b3ee1be889773c34ba9e7a"
    sha256 cellar: :any,                 arm64_monterey: "76eab44501da3c25d487810decd0fcf1eaf3cf9a86b3ee1be889773c34ba9e7a"
    sha256 cellar: :any,                 arm64_big_sur:  "76eab44501da3c25d487810decd0fcf1eaf3cf9a86b3ee1be889773c34ba9e7a"
    sha256 cellar: :any,                 ventura:        "8756a469f2996cac8c18fe0ebd2ae3ab7aa527d93036db3044f89c5716f1c294"
    sha256 cellar: :any,                 monterey:       "8756a469f2996cac8c18fe0ebd2ae3ab7aa527d93036db3044f89c5716f1c294"
    sha256 cellar: :any,                 big_sur:        "8756a469f2996cac8c18fe0ebd2ae3ab7aa527d93036db3044f89c5716f1c294"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0845bd8cb72b7ef0a9e2d459b3d5d0be4ee5675f48d7c53609c612df39fa76a5"
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