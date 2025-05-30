class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-40.35.0.tgz"
  sha256 "9828a1644e863363de4db492d9204de00df3579153f05861ac5e20d069bc16b9"
  license "AGPL-3.0-only"

  # There are thousands of renovate releases on npm and the page the `Npm`
  # strategy checks is several MB in size and can time out before the request
  # resolves. This checks the first page of tags on GitHub (to minimize data
  # transfer).
  livecheck do
    url "https:github.comrenovatebotrenovatetags"
    regex(%r{href=["']?[^"' >]*?tagv?(\d+(?:\.\d+)+)["' >]}i)
    strategy :page_match
    throttle 10
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1a1b07c2c4d217152ea8a64f4b89dd2f4fe7d7d76a4891463ac39384b4db63b1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4acfbc06aed83a28cc12a48d0b42330de17c3946ebe7fa579a6b3eb0c17fc6e7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d731c96517b56885fdc087f342f3ea98223f51557a9b2bb836458462742c8f94"
    sha256 cellar: :any_skip_relocation, sonoma:        "93f721cdf428fed7640c49501a6551012c6b7df88d4a2123decc0078d39c4294"
    sha256 cellar: :any_skip_relocation, ventura:       "338e39a0801b3a0f9280f3c954c280ef02c0b316f2e1293a5bd2b92fc6a7f654"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "31437d97f60ceb1821b6aaae4b155d7f0ab59e7c1aa1345bfd8f89882d7c0f60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "737702224fa6d9992d837ec3d5b01ad259f78f6db6a50caf03c45654145a7ca1"
  end

  depends_on "node@22"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    system bin"renovate", "--platform=local", "--enabled=false"
  end
end