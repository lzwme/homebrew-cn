require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-35.95.0.tgz"
  sha256 "073c4068593734932f4820e6d974f4bda6cc32dabdf334c6ab0a6c9530046907"
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
    sha256                               arm64_ventura:  "c270bb283bb2d5b39d53bd7d1cf25778987d56f9a8c38e977d9433370e435d6a"
    sha256                               arm64_monterey: "7413034488dfc5c58b2c8885998d7685d236f49e0a51fed1bf08dffb9d8914c9"
    sha256                               arm64_big_sur:  "c2d1132479036263d198aefed40c3569d80a93a0c4ea41b2060aad8a82b69b75"
    sha256                               ventura:        "e43e9a3cad79d46e0abc6fca6c6d7bfc3bc16aa937bedad5a647bc24633cc9b9"
    sha256                               monterey:       "8ea64044411809630602bbe4fda4d5a7d024222492eaa04dcaed165722683be2"
    sha256                               big_sur:        "623bf27fa78faea526000b49a42089020e34b629d0ba797ead11fee46b0f19e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6efc63c3dbbe7ac8b6063a29a0ddc3bfcfa1fc3bf5c19ee88ae14f124c729e57"
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