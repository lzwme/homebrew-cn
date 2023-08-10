require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.52.3.tgz"
  sha256 "5d49cf4ffa95a10a360c42dc8985d7bd5cff55800ec6ddbbb57409a21f95a1d7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "12b9207c6ec2f4fa22165ca9ceba7ae30626e7ad4ad502e88e112b0a02a4ce2a"
    sha256 cellar: :any,                 arm64_monterey: "12b9207c6ec2f4fa22165ca9ceba7ae30626e7ad4ad502e88e112b0a02a4ce2a"
    sha256 cellar: :any,                 arm64_big_sur:  "12b9207c6ec2f4fa22165ca9ceba7ae30626e7ad4ad502e88e112b0a02a4ce2a"
    sha256 cellar: :any,                 ventura:        "8035293279ed868e81419e94be668a74f307089a6c79c8763ecfe9f843bfa446"
    sha256 cellar: :any,                 monterey:       "8035293279ed868e81419e94be668a74f307089a6c79c8763ecfe9f843bfa446"
    sha256 cellar: :any,                 big_sur:        "8035293279ed868e81419e94be668a74f307089a6c79c8763ecfe9f843bfa446"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee7551040667664d0dab80bcaea72edb43030a6b2c38d9a25e31e23bc162233f"
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