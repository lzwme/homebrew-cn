class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-39.178.0.tgz"
  sha256 "becd2991de5fda50c8287ffe768a7e6e3c1da2987e10bd091d668b71dc9970da"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "40e8aabe9f9abab25ff1a4587321c7f23413c08c0ea487a33b0cd066df72c201"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "789254ce3ddc549c701e668466ad3fb780b4a164f08e82f8414948cc7c2e5cbd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4d2f567efcefeac655fca2bd2398745f532e1d284f1ad1127fdc39d19eb43a6b"
    sha256 cellar: :any_skip_relocation, sonoma:        "b6109cf2d73382143b9f25e565419c4445703363c18fc8ae883a0e0020587949"
    sha256 cellar: :any_skip_relocation, ventura:       "2b2cc30c51e5275cfcd13315da48490ba8ab4eeeae39354c2c488bf15dc29f3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "78b75e4b213a3dd4a386fccc10c0926d5cc0ec152add4ebbf6788442b52c50f6"
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