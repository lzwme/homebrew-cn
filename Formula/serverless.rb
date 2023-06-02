require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://ghproxy.com/https://github.com/serverless/serverless/archive/v3.32.1.tar.gz"
  sha256 "05c98e4e2d2bd8c5aaa2d7475afc4e40d8f79a3f75d961187e5fe74ad5f32983"
  license "MIT"
  head "https://github.com/serverless/serverless.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d261ab7406d81b6afca960f5242920e2e9d3670d7d6b7744b930670bf87b8f77"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d261ab7406d81b6afca960f5242920e2e9d3670d7d6b7744b930670bf87b8f77"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d261ab7406d81b6afca960f5242920e2e9d3670d7d6b7744b930670bf87b8f77"
    sha256 cellar: :any_skip_relocation, ventura:        "5de7f128188a079363068fde3803e6c9f696b45d2ec93dd23486f452bfbcc9cf"
    sha256 cellar: :any_skip_relocation, monterey:       "5de7f128188a079363068fde3803e6c9f696b45d2ec93dd23486f452bfbcc9cf"
    sha256 cellar: :any_skip_relocation, big_sur:        "5de7f128188a079363068fde3803e6c9f696b45d2ec93dd23486f452bfbcc9cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fd4955d880008361015ac8994d2b242d9c13c12dbccc99de24034cac8fea3d70"
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