require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-36.97.0.tgz"
  sha256 "873403bd92586bd31cf8ba5d5e6a3e98ef3d573f2cfefe3ba6be5377b74069c4"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d1c5a18be1a530dfe18c268260d9c02e10f7c7b3b405731864444150d0e2b01e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9673fe61999f04600637a2c7ddb48279fde6875040f1aeb960f17b41ca72559e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9c753866dffeeb84516d208c902531319e58fcfad98be2204ddfada3250c9fb3"
    sha256 cellar: :any_skip_relocation, ventura:        "b7a33286b2250b3220ed832a1f643a65b4c4d94e73d1c601cc182737d9a28d99"
    sha256 cellar: :any_skip_relocation, monterey:       "522a79bbbeb31ce2903789309d1a41b0b59845683aaa1648f99b4f1417efb03a"
    sha256 cellar: :any_skip_relocation, big_sur:        "263f6ece75f738792841500c3b98ce5f55f3806996b4530faf30d63144135241"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e20e746e8a1ced4684c122b21b0b1489ce3f05d34467c63b3665a9f8b9548506"
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