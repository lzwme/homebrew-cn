require "languagenode"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-37.382.0.tgz"
  sha256 "49799999728f843842b3bc2ab682d0e47aa3bf69413eef3f2d04a80dbe09787e"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "db1d2c9f85dc7f4c347b9408cb10e9c3ca074ab8248819c5d2764b987c278e5f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "216520b5477483f01aaac15d12222041596f98bb80e2b2bc6345387f58b3e584"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d6ee5c0504761cc7a0258daa681e6c6bb25e6f934cdf79e147188349978c24e4"
    sha256                               sonoma:         "738a89b87016f15df6e7c15c259a1b2df382f8e46d501c5225bd00bff05589d7"
    sha256                               ventura:        "95a124d0d0213fbb71914800a9a90538df9d83eb8e347d72843d8e69fa4050b8"
    sha256                               monterey:       "346b086af4bee0784b4dce3d9f53f9c19e8710199990833fb3a024b84612976d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c7c568324203106323701c08b05b5ebe21e8fb320ec1ad81c3ac9121b73dd79c"
  end

  depends_on "node"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    assert_match "FATAL: You must configure a GitHub token", shell_output("#{bin}renovate 2>&1", 1)
  end
end