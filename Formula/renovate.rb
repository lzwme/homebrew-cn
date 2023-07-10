require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-36.6.0.tgz"
  sha256 "896c74e502c9811215e043403d0135bbf33362ebf4db20c466600d45855c7767"
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
    sha256                               arm64_ventura:  "e0c6fbdf969fffb9cbe97171e5a8a135e751ad53dcc7d064a75d7f040af26263"
    sha256                               arm64_monterey: "e9d935318346c6314407ce4e4849095832ea8b1a5908a3fac5bd911c7f660d47"
    sha256                               arm64_big_sur:  "a3c1e158cbe71611854333334ddfb5c6ed88b52299dcd9710b656a699a32673a"
    sha256 cellar: :any_skip_relocation, ventura:        "724ed7274147f9cf0852ebf67092d8af045093e2b663db8766f344299033ce8e"
    sha256 cellar: :any_skip_relocation, monterey:       "e914340c12e344bee3cc350de9b288463047371ce6727721f66da94f11103d3b"
    sha256 cellar: :any_skip_relocation, big_sur:        "854957436eb995aa881fd898e35765786287a55a9ba61ca1024d96b072695609"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fc72499e275f62d97935b03312801f3c8b836e2a794eab94ad3121d3906e668a"
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