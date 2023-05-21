require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-35.97.0.tgz"
  sha256 "8723b3dd5cf3bff8cb7eb4dafbd760fa10c0362ca51d786c86b6c3b2f9193f56"
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
    sha256                               arm64_ventura:  "8574d8f7a9e44232d6ac73a702b6a94a1427e70dfb7e738b8a064b4219684642"
    sha256                               arm64_monterey: "29980fef371310e8d0ba727cb91b6adfc27a01eaee44a2419101549c4f618aa6"
    sha256                               arm64_big_sur:  "681772d494c355341663df22b8958c6fdabe46135e478c2a88a5874a0412f302"
    sha256                               ventura:        "da3d6b497d83ccb48d243aa4933bd590657f0c507daea87bec5ba087d531b164"
    sha256                               monterey:       "d51dee6f594653f67f6baef3f7beba840abb3752fff644304ec0471acd059529"
    sha256                               big_sur:        "4f899b69e8d3d73e42f242593102c29451b9d3a8075b6a73004d26c30e5f65df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e7fa3eb69ad4b07ccce59bb817ecb67dd658da400c627b1b0dab1fc03d4094b3"
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