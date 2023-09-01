require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-36.78.0.tgz"
  sha256 "f9b1f856b1f9100f04ecb122b6b033f348429fcc7372438566ad03fb4c29b2bf"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1767cdd6549602759a776acbf26d3f381f0057939201e82a9ff5b4e936ee8882"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ceb7536b478468e8d918bd52294c73552b04f21c1489565a6dec4ab1e3a57a08"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2c0eed11344165108acf0ec4b9c4c5355434e17940829dce36853ca0627a709e"
    sha256 cellar: :any_skip_relocation, ventura:        "66938dc1323a6549b36c9a280f84f3ed487030cc04ed25026955c4c96ab1ffb3"
    sha256 cellar: :any_skip_relocation, monterey:       "be0767b1ee7edf1a5e39f1dfa84077ab764bec99cacf1509ea5c9cc5ede6a58a"
    sha256 cellar: :any_skip_relocation, big_sur:        "178cb48f97c9132c03830868bab6017a50b1c3f5720e345004c552fde4f2af45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3bda4448633bbcd76cbd232f2df5d60101ce9065c60a430d0683ed52c4f1e448"
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