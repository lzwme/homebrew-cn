require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://ghproxy.com/https://github.com/serverless/serverless/archive/v3.31.0.tar.gz"
  sha256 "49b1a3b6b6b3d93211f8c289738ef0d746fcd84c3a8f91a403b0df7f3cba47da"
  license "MIT"
  head "https://github.com/serverless/serverless.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2c053f66c86c566a471a1ffb185cb7aae430e4b3f23f8e2f4cd80c531d088459"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2c053f66c86c566a471a1ffb185cb7aae430e4b3f23f8e2f4cd80c531d088459"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2c053f66c86c566a471a1ffb185cb7aae430e4b3f23f8e2f4cd80c531d088459"
    sha256 cellar: :any_skip_relocation, ventura:        "23a2468c414f95ecd2be6bc53fc9ef76438bc8d4998fd343186da4fd1c89d9c5"
    sha256 cellar: :any_skip_relocation, monterey:       "23a2468c414f95ecd2be6bc53fc9ef76438bc8d4998fd343186da4fd1c89d9c5"
    sha256 cellar: :any_skip_relocation, big_sur:        "23a2468c414f95ecd2be6bc53fc9ef76438bc8d4998fd343186da4fd1c89d9c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "63a94d1b34210965ca91cdd9e8f3b64e0de19665848783fbe4bdc159f634a9aa"
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