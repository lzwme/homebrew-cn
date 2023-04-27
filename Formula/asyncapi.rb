require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.40.3.tgz"
  sha256 "f6b6eb612389b4eaaf69bb8998b0b9169cab639e3cde1ffd7f520ed59f6f4633"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "07724fe6f77a4780ced846e5002dc1e0d9b81fa58d3283deefca8de808eb2b18"
    sha256 cellar: :any,                 arm64_monterey: "07724fe6f77a4780ced846e5002dc1e0d9b81fa58d3283deefca8de808eb2b18"
    sha256 cellar: :any,                 arm64_big_sur:  "07724fe6f77a4780ced846e5002dc1e0d9b81fa58d3283deefca8de808eb2b18"
    sha256 cellar: :any,                 ventura:        "8611d6db1f5780d3ac1489c6b25c3ff74eb93060a7f0dc8a626a6dfb90e9f7be"
    sha256 cellar: :any,                 monterey:       "8611d6db1f5780d3ac1489c6b25c3ff74eb93060a7f0dc8a626a6dfb90e9f7be"
    sha256 cellar: :any,                 big_sur:        "8611d6db1f5780d3ac1489c6b25c3ff74eb93060a7f0dc8a626a6dfb90e9f7be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "10732990801f08cf2f156622a955d882d5b4a18746b7a749b84bc240d4cf1756"
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