require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-35.118.0.tgz"
  sha256 "7393411a1ac501a8aa6bc8f37dba5264e656925528472030beb3594a1d589221"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6e395eebcbb3406086f87153da6f5e0a5bb7d10c46cb29f784b2fdf344a437e2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "51f3fbc2191931570e2e94e00b60d2f3e2f619b04ba258e17761f66ce7b97b05"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "19e0b7bb2eb797af36671d1795a4887922871a74d33c47f6805047abb94a3459"
    sha256 cellar: :any_skip_relocation, ventura:        "820bfdcb2a16ead8c87e8b3f1adc7797483ed7d3335696756bf4d2eaf506f226"
    sha256 cellar: :any_skip_relocation, monterey:       "99a1f9c9030b0af05eb0524a554a1723077a62558693aeb10b10b83c86c304de"
    sha256 cellar: :any_skip_relocation, big_sur:        "598d403901962d7f648646f3c895e3fe7036cbb0a753ff829b7b4f44b10705d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6e4ae49c3a7065a8c4edb67f3069cfd2d3bbab3fab54edd4895745a0e2ef582e"
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