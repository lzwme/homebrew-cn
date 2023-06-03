require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://ghproxy.com/https://github.com/serverless/serverless/archive/v3.32.2.tar.gz"
  sha256 "bebab64293df2538ece5d66a629ef8096ea001e12dcbc94de8f266a8d23be9c3"
  license "MIT"
  head "https://github.com/serverless/serverless.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f0fc5c797b75d29c0f8e4c01fbf7598b2295fccfbcf77dd34b6bc467d6859dc9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f0fc5c797b75d29c0f8e4c01fbf7598b2295fccfbcf77dd34b6bc467d6859dc9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f0fc5c797b75d29c0f8e4c01fbf7598b2295fccfbcf77dd34b6bc467d6859dc9"
    sha256 cellar: :any_skip_relocation, ventura:        "a8c8d73d3f799c58bb8d06b19cd921e7575810c5fbcea359e9e915f4f221c53f"
    sha256 cellar: :any_skip_relocation, monterey:       "a8c8d73d3f799c58bb8d06b19cd921e7575810c5fbcea359e9e915f4f221c53f"
    sha256 cellar: :any_skip_relocation, big_sur:        "a8c8d73d3f799c58bb8d06b19cd921e7575810c5fbcea359e9e915f4f221c53f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f16a0a7836037d273b8e899250e9eee5f9a0f6217deaab84c17ee37cd5b963b8"
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