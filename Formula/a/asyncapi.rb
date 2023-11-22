require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-1.1.0.tgz"
  sha256 "57e4439f50aca530da7526bac84aa82ca0a9ffa7666a53a09acb4cb834357e83"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "6dcb2e192cf54c38c450fbe4dc49adcb1874df31725f93a7ddbd5c64b20df547"
    sha256 cellar: :any,                 arm64_ventura:  "6dcb2e192cf54c38c450fbe4dc49adcb1874df31725f93a7ddbd5c64b20df547"
    sha256 cellar: :any,                 arm64_monterey: "6dcb2e192cf54c38c450fbe4dc49adcb1874df31725f93a7ddbd5c64b20df547"
    sha256 cellar: :any,                 sonoma:         "f39c0b4eebd0b1967567ab7b9f330762587bd1b3a0c992822885c940c5bf0a27"
    sha256 cellar: :any,                 ventura:        "f39c0b4eebd0b1967567ab7b9f330762587bd1b3a0c992822885c940c5bf0a27"
    sha256 cellar: :any,                 monterey:       "f39c0b4eebd0b1967567ab7b9f330762587bd1b3a0c992822885c940c5bf0a27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "22ed08f083717dfdf8fea5c31dd76f63178b8eda9aa190744943ac8eddb7a4dc"
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