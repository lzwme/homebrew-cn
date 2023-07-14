require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-36.8.0.tgz"
  sha256 "23038ed9b223ac0cc8b4780ea876fed0c8b81567922bd4d25e71e0316720c9a2"
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
    sha256                               arm64_ventura:  "4501e749ed26753dfd787bd8d453f85591ca37f77a8026cde66b052681fe1548"
    sha256                               arm64_monterey: "d6f0c058b11b08b4051d29820d4e0aa5836a40a8ab7746ea83469fa2000cfebd"
    sha256                               arm64_big_sur:  "59283a7d4230cfc4740cca4506f8b78a9b3de6ac2e41f87c67f14f2497809c0c"
    sha256 cellar: :any_skip_relocation, ventura:        "cf69808d571f9088981e482832ffd6d0c7431b0954d453baadae9c92e8d5e89f"
    sha256 cellar: :any_skip_relocation, monterey:       "b8709ecd902a40f601f93d8841d8fe919b6eebd269979e02a31301ee0f6aced7"
    sha256 cellar: :any_skip_relocation, big_sur:        "d39327317ac513d81336c3a1367d6f9014c28b329fa8ccb58d13bccc60442697"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee2f2acba65f868800acd898198a9313c4061eb433209727080aff58eea4412b"
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