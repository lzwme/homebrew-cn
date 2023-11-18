require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://ghproxy.com/https://github.com/serverless/serverless/archive/refs/tags/v3.37.0.tar.gz"
  sha256 "1d417226d4ff82c827a4bf72ccf7919e655098a1df1f67d0daadfa45243e339e"
  license "MIT"
  head "https://github.com/serverless/serverless.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cf29a0cec9c36000569e9917c24dd4d2ea36ea406c85aad7c52ea72513dc1294"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cf29a0cec9c36000569e9917c24dd4d2ea36ea406c85aad7c52ea72513dc1294"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cf29a0cec9c36000569e9917c24dd4d2ea36ea406c85aad7c52ea72513dc1294"
    sha256 cellar: :any_skip_relocation, sonoma:         "bb10a3e39f6ec11496f0bedf8ef28c506e604d1b8f92560707974c17842f6f19"
    sha256 cellar: :any_skip_relocation, ventura:        "bb10a3e39f6ec11496f0bedf8ef28c506e604d1b8f92560707974c17842f6f19"
    sha256 cellar: :any_skip_relocation, monterey:       "bb10a3e39f6ec11496f0bedf8ef28c506e604d1b8f92560707974c17842f6f19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aadd4760de262486dbcfc803294b7238595b5408a192146718b07c5aee6e6a62"
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