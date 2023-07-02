require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-35.154.0.tgz"
  sha256 "a3be5fe12baaf48a4da9ec580b9a94433f67af556a4d5f8e062a1b4ce0e75c63"
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
    sha256                               arm64_ventura:  "faaea39e58e0ac4b531d9d9cafa7d57fb54d1e06c8200c9569b3c147b045a6a4"
    sha256                               arm64_monterey: "b708cf194ea29b1a0b53d0283cbf3d4b9ab60d69350ed5329d63c26b83aefe1f"
    sha256                               arm64_big_sur:  "432f858837d5cce59b76ec836fea5b5700ad21dfaffe72df4e7ca7a96be7ac2e"
    sha256 cellar: :any_skip_relocation, ventura:        "25d6bf0fc890e5af862cc89d15e3f2245bdb7c8fe80b09c45a6634300d5542b1"
    sha256 cellar: :any_skip_relocation, monterey:       "8fac70c7f476a71dec85cddd84f3c614ad0c19cf5adc012168cfa48e9b972148"
    sha256 cellar: :any_skip_relocation, big_sur:        "2b466876409d55dfd534b6450eebba4f5d2d3a39b15eee03856ccd0ea97197aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4ecb1b34db4cbf0352c27049f2bf558168e9bd8faae8cad455bd30089935f127"
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