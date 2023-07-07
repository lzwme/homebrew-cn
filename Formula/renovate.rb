require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-36.1.10.tgz"
  sha256 "621ac73cab432c7dc67ab2a2bd4157ee82b11e46a4ff312b936b2ffa92ded152"
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
    sha256                               arm64_ventura:  "16d332aa5dd67ee037619fddfa3cdbb4677b421ae5796dd49e1c83f05bdeca12"
    sha256                               arm64_monterey: "d23b6d786f2d6d633fdfc76b1ff6cdae4d7dff3b02ec81cca3ab35b71903edb8"
    sha256                               arm64_big_sur:  "5e9277c5e0139e8d4338ce6024e577a446f165b85f96440bfa3335fbb6baffd2"
    sha256 cellar: :any_skip_relocation, ventura:        "0f8372e8b0fc130ed0e84692d0f2282f7c5e8d20bedfd78eefbd9585f588b1ce"
    sha256 cellar: :any_skip_relocation, monterey:       "fcd716f7d121f1079811cbb81189e5b4085c7c50ef217602e9fd1924f07bde35"
    sha256 cellar: :any_skip_relocation, big_sur:        "a2b18743968310096a00ed316e398efcbaab966ed9dc3a61b78e6ffaa00de6c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "99f66c4f80f766f10e9025c9248bf7f1b0d098b3ffb8b0f6a903ac003cc956f2"
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