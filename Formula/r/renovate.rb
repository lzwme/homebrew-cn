require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.49.0.tgz"
  sha256 "0975e4c1bf3190cac44327dc3ff6b3fa518663e648ac9b842c4447caf8df70c5"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "28a56b5a1feb08abc3273fa7106c78e1e05c06242575cca84783da4cd7e73bcf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8067fe9b0e944e153b8b4b6fa560777ac955dee42d1c04108516f41c9d14e64a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1a71d8cfa010cc8f72f74440294750372697e38b78db57b03dc02d8087101e94"
    sha256 cellar: :any_skip_relocation, sonoma:         "a43bcbc04b31d312439a731d6cbfb928d96b823da0ac9442541c1f8876c46c8a"
    sha256 cellar: :any_skip_relocation, ventura:        "025d11c7a25f2959ec2593c0ce3242f949416e85cddfb3937da296f3d92a12ae"
    sha256 cellar: :any_skip_relocation, monterey:       "16165980e6f379c55c3e7b039552872c2d23b66392fd52dff1560452349550bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b64a5d9e4a069e3cbd761e6825e8240144383632869920ba352b500b0001dc29"
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