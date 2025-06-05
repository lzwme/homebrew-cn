class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-40.41.0.tgz"
  sha256 "8287f7bf23bfa2076b07cb943b9611183f768726eba745634de4ceadfa0cf652"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f38374764952eff7fada93fa8c722397732686fa75d5ba46398f4b0ed0baf498"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2ad2ccdaa564baf81cd5094a2c709e53d3f0d806a51e4d7b87e2e4ca6834dece"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "44b846deed99ce64a4e6a6035c09682e6586bd992ff01d071ca61a4e451fef87"
    sha256 cellar: :any_skip_relocation, sonoma:        "715e0169fff1b2428ea1858fb3f53596ba7c1c139e7fec481571134f91bc31d5"
    sha256 cellar: :any_skip_relocation, ventura:       "96344ed6cf2336048aa9e4c5e87ef40deb6ec40892e235ec7ecebeb189972afb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "16d5f1b6c82d0bafa0a2d9cf082685f18b8a77c1304e796cf3d05afaa83b1f98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fcd1dc127903671c542d00a4970f76cfd2460d150546207619bcb5de75a32bce"
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