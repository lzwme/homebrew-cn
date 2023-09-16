require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://ghproxy.com/https://github.com/serverless/serverless/archive/v3.35.0.tar.gz"
  sha256 "572b7f25ce097c069c4a37614f863d2eb0b86ce87e17609dab114ece0e929487"
  license "MIT"
  head "https://github.com/serverless/serverless.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ce986600073b2545b2924506d6f73e43b28c48021c988d857c44220296f4fb3f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ce986600073b2545b2924506d6f73e43b28c48021c988d857c44220296f4fb3f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ce986600073b2545b2924506d6f73e43b28c48021c988d857c44220296f4fb3f"
    sha256 cellar: :any_skip_relocation, ventura:        "a9215c8a15d6fbba5002c6a0b59602fc987027ca11986094f2ca3bc21eb03d00"
    sha256 cellar: :any_skip_relocation, monterey:       "a9215c8a15d6fbba5002c6a0b59602fc987027ca11986094f2ca3bc21eb03d00"
    sha256 cellar: :any_skip_relocation, big_sur:        "a9215c8a15d6fbba5002c6a0b59602fc987027ca11986094f2ca3bc21eb03d00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0f28e9e829bdd5b99eaa2677e8f0584b6f3d4cab8f56e5dfa548b8007431545b"
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