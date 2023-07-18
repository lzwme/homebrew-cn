require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-36.9.0.tgz"
  sha256 "adbf107c89838cc8ea969d1afb197248ce379d68ba2db2cefc06b8e6af6535b0"
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
    sha256                               arm64_ventura:  "f64f156eee55969673c1be67707bbd73ce24c00234c2e4adbc12c9d0d723ec07"
    sha256                               arm64_monterey: "d669c62e05e240970410c45d0d0d5add0b411cbd09540684eb075dc28202313d"
    sha256                               arm64_big_sur:  "743cbd1d41afb4066723b64e53720a21b3f16f1dc7cb27a376e7f74f5ad205e5"
    sha256 cellar: :any_skip_relocation, ventura:        "0e60aa4ab9ac733139dec42d8cc0367ff2791a443eeddf5c0deb6213617261c6"
    sha256 cellar: :any_skip_relocation, monterey:       "f03e1b762ce3b9f1e1f5c5fe5cf5a6024b67561095fee76c124ff9309e0934d8"
    sha256 cellar: :any_skip_relocation, big_sur:        "d2eca270b0e786dfb0ff9bf22e631589703b6c7062eae405202f100c61e4c84a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fc79836725d3d3f331261489ca5dc4b0be08c15e825e635af20f6d1615ad2fc7"
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