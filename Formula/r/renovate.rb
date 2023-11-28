require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.70.0.tgz"
  sha256 "883f1393737406a46dabe3ab357ce921c601c29cbe6bfc4fc63036f4a775c923"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1e816709f3b7af068661e0e60b145973450ab822ab6b5e68684a699217ed6694"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ae7e996f8c97998efe98825f6c2a91b28d67085876ec5daa589257848bca60c1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "07c8f1bdc2a92ff516d4ac0e27e29607b3a748a0a0042af510f07ae31195d970"
    sha256 cellar: :any_skip_relocation, sonoma:         "f3a536101ab45f5a97d11a00ceabed181f35f8b6aaa69b73a8df30ba670949de"
    sha256 cellar: :any_skip_relocation, ventura:        "ad3ab4ca91a28299e67f9067d3ef36132c1eb460ac20bcbe76dba4690be623e0"
    sha256 cellar: :any_skip_relocation, monterey:       "6c5b248e3407178c000531d866981a7badc8dc8a12b09b1f1b2f63387901b8c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "700ff8636f316ffe875ff012ddffc8b314d6555f746cbf65e7b480955745722d"
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