require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-36.45.0.tgz"
  sha256 "002fcacac5546bc65ed00b894c5aac1ab544f46eabe84d1604aed4c56b0af993"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5762818d0d066089fc0607bddd6fae9250c4a0408c0085b7f49f4785a5b8d467"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ab9cc854581d78508f75095dbd903f2087ab3eaa17e56aa6981c3fed97796f72"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "de9e9f8874f7ce33e168fbf2c90853741bab25cd6006b2647f9343666cd31a42"
    sha256 cellar: :any_skip_relocation, ventura:        "351fcc265163a2e74609ac3bd000ea0e67ea68b9e4e07261863bb5d3de409b5c"
    sha256 cellar: :any_skip_relocation, monterey:       "a94f158653c5e72b297c307ca34d583ed57ee466bcdc1e2d21a3ebbd27329098"
    sha256 cellar: :any_skip_relocation, big_sur:        "6f626fc10eb7cf51e3250e17cc98cf67d2f448d8960f454f86016a9136386c2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "63c60902bfe9dd4841b3638b7937c7a64514dd758aeaf4e6b36044792d76c1c2"
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