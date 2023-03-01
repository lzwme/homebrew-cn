require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://ghproxy.com/https://github.com/serverless/serverless/archive/v3.28.0.tar.gz"
  sha256 "b668936db713e61ac891c38078c20687e9805f996e183d397cee56f96d9b0381"
  license "MIT"
  head "https://github.com/serverless/serverless.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5edee9238db85cc876642ce5902c08c9e40cf4e70c690e8f677cac6c1f4d3641"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5edee9238db85cc876642ce5902c08c9e40cf4e70c690e8f677cac6c1f4d3641"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5edee9238db85cc876642ce5902c08c9e40cf4e70c690e8f677cac6c1f4d3641"
    sha256 cellar: :any_skip_relocation, ventura:        "f9f92542c027e500d92ee17e25def991b2fa4955eec781ecf4d58c05588f462c"
    sha256 cellar: :any_skip_relocation, monterey:       "f9f92542c027e500d92ee17e25def991b2fa4955eec781ecf4d58c05588f462c"
    sha256 cellar: :any_skip_relocation, big_sur:        "f9f92542c027e500d92ee17e25def991b2fa4955eec781ecf4d58c05588f462c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6785f4f73d487842c345d84cd015317e642883524978da35b37d6d4b5e243f2d"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir[libexec/"bin/*"]

    # Delete incompatible Linux CPython shared library included in dependency package.
    # Raise an error if no longer found so that the unused logic can be removed.
    (libexec/"lib/node_modules/serverless/node_modules/@serverless/dashboard-plugin")
      .glob("sdk-py/serverless_sdk/vendor/wrapt/_wrappers.cpython-*-linux-gnu.so")
      .map(&:unlink)
      .empty? && raise("Unable to find wrapt shared library to delete.")

    # Replace universal binaries with their native slices
    deuniversalize_machos libexec/"lib/node_modules/serverless/node_modules/fsevents/fsevents.node"
  end

  test do
    (testpath/"serverless.yml").write <<~EOS
      service: homebrew-test
      provider:
        name: aws
        runtime: python3.6
        stage: dev
        region: eu-west-1
    EOS

    system("#{bin}/serverless", "config", "credentials", "--provider", "aws", "--key", "aa", "--secret", "xx")
    output = shell_output("#{bin}/serverless package 2>&1")
    assert_match "Packaging homebrew-test for stage dev", output
  end
end