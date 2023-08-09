require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.52.2.tgz"
  sha256 "ad206f4536532c373189f0a38ea543852c04590be932ccc7b17967d58b89cd72"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "965c92eacf378fbd70a6cb677492938720bf8d06aed2c2d806b218932e93982f"
    sha256 cellar: :any,                 arm64_monterey: "965c92eacf378fbd70a6cb677492938720bf8d06aed2c2d806b218932e93982f"
    sha256 cellar: :any,                 arm64_big_sur:  "965c92eacf378fbd70a6cb677492938720bf8d06aed2c2d806b218932e93982f"
    sha256 cellar: :any,                 ventura:        "50f02df27776c26436058521cd3272d6baba4a8fafd6e1a95b9b654dd3811f4b"
    sha256 cellar: :any,                 monterey:       "50f02df27776c26436058521cd3272d6baba4a8fafd6e1a95b9b654dd3811f4b"
    sha256 cellar: :any,                 big_sur:        "50f02df27776c26436058521cd3272d6baba4a8fafd6e1a95b9b654dd3811f4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "44cdf1fa0aa230cc0b8a9fada2e78faae5ea63d0e0ffdbfb49b4e4a6bab9365d"
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