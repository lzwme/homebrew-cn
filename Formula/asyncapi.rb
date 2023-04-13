require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.37.2.tgz"
  sha256 "2af81bb6965a729ed8e62779fdb884b5a0cc0251bd444abb7fdc09ddf1ef56b0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "3db87d472b93faea72a45a3e335846f2729f82682e6e99c0d4828a8408e3dd18"
    sha256 cellar: :any,                 arm64_monterey: "3db87d472b93faea72a45a3e335846f2729f82682e6e99c0d4828a8408e3dd18"
    sha256 cellar: :any,                 arm64_big_sur:  "3db87d472b93faea72a45a3e335846f2729f82682e6e99c0d4828a8408e3dd18"
    sha256 cellar: :any,                 ventura:        "c97be77042b6d67337904dbe59bf09ce2c6e04c6678b143c2bbc23df27ef3ac5"
    sha256 cellar: :any,                 monterey:       "c97be77042b6d67337904dbe59bf09ce2c6e04c6678b143c2bbc23df27ef3ac5"
    sha256 cellar: :any,                 big_sur:        "c97be77042b6d67337904dbe59bf09ce2c6e04c6678b143c2bbc23df27ef3ac5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a49ea5a09fabf9071ab5e76db2463bbe0b679fb46c6bcddff1280c3e984a36e2"
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