class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-38.105.0.tgz"
  sha256 "beb3d017762520f81c3a77e09ff1daeb4e37f3d3b54aadf3d07d9b47e5506427"
  license "AGPL-3.0-only"

  # There are thousands of renovate releases on npm and the page the `Npm`
  # strategy checks is several MB in size and can time out before the request
  # resolves. This checks the first page of tags on GitHub (to minimize data
  # transfer).
  livecheck do
    url "https:github.comrenovatebotrenovatetags"
    regex(%r{href=["']?[^"' >]*?tagv?(\d+(?:\.\d+)+)["' >]}i)
    strategy :page_match
    throttle 10
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "672f1c2f014487c48151a85cbe75cecd23d606503b6d699410408112ed2dacf1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9b7e557b1cb28804be9dedee87c0cf4f1ba7a969aae51ee7030a588c6c246715"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f6434372c0afae1a0ef520be7df774a6827d70bf4479b55e71148b7b4167b7d0"
    sha256 cellar: :any_skip_relocation, sonoma:        "9e093e3c0618d57edd66e1076e51566cc3578740195c7c41b800a4086c740588"
    sha256 cellar: :any_skip_relocation, ventura:       "839028a519ef3b6d6bff08202efb4ca1d41c2f5c828ca4f6ca6da4941a4dae46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec482e10836968f3985674a7156dbd50ad298b7b3f1baf0c0a5416505a0a87a7"
  end

  depends_on "node@20"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    system bin"renovate", "--platform=local", "--enabled=false"
  end
end