require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://ghproxy.com/https://github.com/serverless/serverless/archive/v3.35.1.tar.gz"
  sha256 "3c6ee649d55607e02858a0bc39335ed107e966bcaa58ea14d82c3abeacccb702"
  license "MIT"
  head "https://github.com/serverless/serverless.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "43ba424de201e270064d2301d88878e6e1ac3c27d8df4d3f875b9f2513ed89d2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "43ba424de201e270064d2301d88878e6e1ac3c27d8df4d3f875b9f2513ed89d2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "43ba424de201e270064d2301d88878e6e1ac3c27d8df4d3f875b9f2513ed89d2"
    sha256 cellar: :any_skip_relocation, ventura:        "1365b498614de5f1d1d7671d40c244a6185858eaabab7cb45675e768ba4066b0"
    sha256 cellar: :any_skip_relocation, monterey:       "1365b498614de5f1d1d7671d40c244a6185858eaabab7cb45675e768ba4066b0"
    sha256 cellar: :any_skip_relocation, big_sur:        "1365b498614de5f1d1d7671d40c244a6185858eaabab7cb45675e768ba4066b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0604b5a89710e6d9dcc41cb6e468d8fffff8b49d0fb227b6ede9e4acb1b0ab02"
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