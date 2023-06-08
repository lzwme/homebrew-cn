require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-35.114.0.tgz"
  sha256 "7e710a4043852f82de31411109c3012166623467970c7b9d5e7ad862dbf820c0"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0d052068d0a3afdd79a76c00386e68a7c33e268017caccd3a46205fd26256d08"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3fef4d74e834481e9f1864e5517a1433ae5685606912a8ae708c4705467a2d8e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "df518dfc99731a81668973d0370331484d9f87f78fe2cd8428df9689c2b40d17"
    sha256 cellar: :any_skip_relocation, ventura:        "a9a10a5b64406379dfb5f2241a6b5598ff4d2dd4db6dbf9176594a73809af61f"
    sha256 cellar: :any_skip_relocation, monterey:       "fcd4b6bd682882d8537b7e06bc1e35db07d68665f7d960b772fcd23c2296ec8a"
    sha256 cellar: :any_skip_relocation, big_sur:        "964c5df5ce686d90146a5548ef51bb6b4b655a9aa22516cbfe684f853901bfc0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9a8cffc5fe8deb28117b794f5ed2e2c9ffd371216bd84037f890a12f12907124"
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