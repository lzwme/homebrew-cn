require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-36.7.0.tgz"
  sha256 "28e46c89377f6b9f79e776e6d037d536ca65f98a215125c4cbf5dc595c849284"
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
    sha256                               arm64_ventura:  "eda84762a2064f113952f3876d68f457ad4fbfe0e4ac91a688fcf9ed57bc8baa"
    sha256                               arm64_monterey: "60bc68b600c2d67f04307949dc5ae88d6c8c6db8ddd7c2a1237fe729a80ddc06"
    sha256                               arm64_big_sur:  "a19115a62c21071930a452ff7b84d70ffaadfaf85b352b20f26140b72d2fc4bb"
    sha256 cellar: :any_skip_relocation, ventura:        "121ff15e57a6dbf0279ab8347e892d3b0060a2ea8f90f4001ff13d6ced927981"
    sha256 cellar: :any_skip_relocation, monterey:       "99a11a0731c1fc49060a0b0f4fa9b4f5c135040dc4c2ea049ed6633231b902ec"
    sha256 cellar: :any_skip_relocation, big_sur:        "b32a84d96d4e71ea5cb4d572020a6b8caaac2bc264701f162728d71d96e1329c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cc1ea30a2f2a73f355f4ed40f1febbb48f22e73e34101c6ab4e66ad0598a989a"
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