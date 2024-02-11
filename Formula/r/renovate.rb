require "languagenode"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-37.182.0.tgz"
  sha256 "dca545d7df683ae2c9c76922be52ba33e590d57e59349c23f87f18952e900253"
  license "AGPL-3.0-only"

  # There are thousands of renovate releases on npm and page the `Npm` strategy
  # checks is several MB in size and can time out before the request resolves.
  # This checks the "latest" release, which doesn't have the same issues.
  livecheck do
    url "https:registry.npmjs.orgrenovatelatest"
    regex(v?(\d+(?:\.\d+)+)i)
    strategy :json do |json, regex|
      json["version"]&.scan(regex) { |match| match[0] }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f28fad9be1bc34bee9e6e2d488e8798c520196a3b8c2cba31c492f598eb75c2c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4f98c4b868f20140b8722b9b86446f8f41e94a2ba7e5389685d2e674b9c1c19d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "df79d3379e78a9742d5d7680d5a0d51a0b3d6c75fbbe21f441e55b827cda3966"
    sha256 cellar: :any_skip_relocation, sonoma:         "49dbaa1a30e4008ad1efd5f139e1ff6e74d62b9ab0b4061a029538fe24437420"
    sha256 cellar: :any_skip_relocation, ventura:        "9bee842f0e9c8a8c2217ecb3ef8e0d5f1f07531667121e41c47f3f665c8759b3"
    sha256 cellar: :any_skip_relocation, monterey:       "07b616d3d3779cd093bd1b19028fb80deebc02e704e46dfd15a332c9feb93bdd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed757bb4cecd64eba441fccd78faa84b979b95748670b34dc1a68ec815f007e0"
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