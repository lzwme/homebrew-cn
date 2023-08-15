require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-36.44.0.tgz"
  sha256 "0d639d3f890c2e421fed801cdced9565efb0d2a7c7fc134cbe2ba317d017696f"
  license "AGPL-3.0-only"

  # There are thousands of renovate releases on npm and page the `Npm` strategy
  # checks is several MB in size and can time out before the request resolves.
  # This checks the "latest" release, which doesn't have the same issues.
  livecheck do
    url "https://registry.npmjs.org/renovate/latest"
    regex(/v?(\d+(?:\.\d+)+)/i)
    strategy :json do |json, regex|
      json["version"]&.scan(regex) { |match| match[0] }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "956c5d42decac18ccbfbcd3fd7c3ebe5e12d2ade7d0fc4bdfeef0bc5bef1400f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "85459c8796851418cff6a44b763c523a046ac4d70050bfd9b72117d0b1dff31c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9f9bb64ae709ecbc035bb1b569d62d796c3e57fd17d20ff2cf935a4d78285eb3"
    sha256 cellar: :any_skip_relocation, ventura:        "9bd699787b02049fa1c8eaadbe2562b68eeb45a6d18f2e8f00b5cd5b88510b26"
    sha256 cellar: :any_skip_relocation, monterey:       "39800872b04359273bbfda0f68f9f63c570141864e7b86c01fb0af1d4238f7a2"
    sha256 cellar: :any_skip_relocation, big_sur:        "ef8e93acbdea99de4e249efe0d2f347ba5daebe7d35fd28d21987d6739dcc33d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "64e888b486e3d2053012adfbe941a49ced071356533ea70358d53ba516fd4574"
  end

  depends_on "node"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "FATAL: You must configure a GitHub token", shell_output("#{bin}/renovate 2>&1", 1)
  end
end