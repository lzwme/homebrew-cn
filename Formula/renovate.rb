require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-35.96.0.tgz"
  sha256 "74ecdbe06a03d1079c7e87654685e1101b470bdc2537134390df8e326803e854"
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
    sha256                               arm64_ventura:  "db9f6ffb833ea70bafd2819dba14660c2cf11edea3b347db10598f0bdc98f710"
    sha256                               arm64_monterey: "3ad7152f0b188c79c08ddda1fa3e2f2d139fdd8303508f756545585f029bb18c"
    sha256                               arm64_big_sur:  "232d1a7616832b29e30416d1157003d0e65c67930021eb46f1711c9c5ed40f31"
    sha256                               ventura:        "e4671441f4b2bd426d70cf460b0a2457248f160334743e9bd999461edcb660fa"
    sha256                               monterey:       "bfd4739e58e1e36adbe052ff0e71039e942fd6e5f3b7733cf2dc5438f6532c39"
    sha256                               big_sur:        "2afac8104f6fa1f71665435558559e790820d27ad4eedf1ee57d6c057bf7fed2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "632f405c87280812fc963dfa19add71029f57073d90a4b6cab6763dfd3f27648"
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