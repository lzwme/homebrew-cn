require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-36.103.0.tgz"
  sha256 "b3ebb6a5c01c972b579e2c7ae7349aa3a8fdfaaec1c54f57174c3f8bbd850d5d"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "86421fa46347a8f6088faee497908131eff41806ac4a56a36399cf0a2ee45807"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a709cff316c7387e19a600574a3f16d5fcde6674081162c8e2dbeab004cca7c6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f80c286fb1d05ec31c5345ec4a10100c3b5ea328d04d5d5415a165cfb722ae54"
    sha256 cellar: :any_skip_relocation, ventura:        "0f94e63526e0cd798ad482ef9de035a4c9812323d5c1c3826677a4a4a15d7f9f"
    sha256 cellar: :any_skip_relocation, monterey:       "ad80135ad18f8eb9285a7f17923e91e4607750614ab46d4497d27cf5dc4527d4"
    sha256 cellar: :any_skip_relocation, big_sur:        "8f0100966542cd18f4d079c067e9183bfc88ec93dd667fa7a824188ad82413d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fdd371853c43545f3c1b1de7d38f41da1d7eaf6d7548d345592f6c7cb548fe59"
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