require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-36.71.0.tgz"
  sha256 "61c28a6260a9f4ec3c4f1494608b9b4920b84462a071c40c9cd9eb3ad9a4ba9b"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cc0fc22a613a58762e523c339796d56105b88d7e636a7110824bee8128f8e697"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d80e4361f1ef77028b415b6a7379c6a7e02bdc53d0db46331ef1997b15b9b407"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2beee073a3a051a44d0f90bfd98dc2ba1fc51cf53531e6e3bf1ae36e69583503"
    sha256 cellar: :any_skip_relocation, ventura:        "a5a2dffcec9ff2503cfc21ac95a37beb68cb53f555eac9b26f40b4e95babbfe7"
    sha256 cellar: :any_skip_relocation, monterey:       "ddeb74e217caf5d076c6e2b9376b88e71c0afec3d9739a10f17570a64213bfa6"
    sha256 cellar: :any_skip_relocation, big_sur:        "676cd40b53bc46fde457e328dfaa3331f71c527caae108c188abe64cfc194616"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "34ed6ad6a61438afac297569f0b1ea45ba92c1b21136b4f7d50606df216c6ed6"
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