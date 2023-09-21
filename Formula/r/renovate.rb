require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-36.99.0.tgz"
  sha256 "5c75e8e5fe57fded79f3683693c8644d35b7be6ada5cfac8b68de83b41d09056"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2878d9d5d5297ba76f84d2c69ceb9e48b72d354c633f9b40d381d6e074b463c5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1724f72de4cf1ddd89c0573c371b6997d6e893afc2f4cb3f7cb568d79c3bc1e1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "77817c7df633326def26f30b7d9a2fc7db1a1e82618d590f72ea40a4c8bb131e"
    sha256 cellar: :any_skip_relocation, ventura:        "2362dfcd521ddaf5aed41d66b327d86b7024e7f0bb8d5c7b1a082ca2ca2e7ef7"
    sha256 cellar: :any_skip_relocation, monterey:       "a81c1f7921c3b5cac3d1ecbbf7e8b62c80a8a56e244150ef4db60ca614bce615"
    sha256 cellar: :any_skip_relocation, big_sur:        "042945b1a14e443972883f397ba28dd179a62133bc077583cf2af293e15f68af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "557be58f60400375424d1e6821abf99c98472c4e92d79649b9b4cb1641460472"
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