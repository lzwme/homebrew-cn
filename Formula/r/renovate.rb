require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.45.0.tgz"
  sha256 "802444153de8169e38cbdd9c753e2e9001c33b0c513baa67d5c1bafda8c74335"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1045f6858961554d94adac59265891d27603eaa21ad18f369a9c92c10769e7b6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f111aeb7e015a67f4c1c91ed1b50e4e81290b15e053450ec3131a83c6cbc937c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d910b98eccee1bfae6ed14e8b31575c186de4e3726f94b2b2d0c40b557f324d1"
    sha256 cellar: :any_skip_relocation, sonoma:         "3de2b06c8cb65db4b022c3fc10ab69a50a11bb4e2f60ca67e470c4c28f32af78"
    sha256 cellar: :any_skip_relocation, ventura:        "7e52cfbd7e929000c1ecae4bc54c25cf85891ee4ce8d20278e3f6f80e8aad6a1"
    sha256 cellar: :any_skip_relocation, monterey:       "52fdd4d633eeb1898d639e7eeef13a0f4edc4caba6023deee6199e57bd4ae019"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2ec4b26f7ed34f6e1ac6ffbf831683c09a7afdd7e29cf487a72bb74ef4b0c957"
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