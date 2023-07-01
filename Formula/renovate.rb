require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-35.148.0.tgz"
  sha256 "40f780ec1eabe8b9cd161ba4a08e67408997e9cefef1179a7710fa918c7e159e"
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
    sha256                               arm64_ventura:  "501f9af3f1a96f21b5166ea6795fc8a5b866e1608bdbc4bc2723201a0f8cf9d2"
    sha256                               arm64_monterey: "3b46041eea2a089bd4dd85ffd0bf954a0a82d7463c181e166edbaf8935ab3a50"
    sha256                               arm64_big_sur:  "006dfc87dce3d20a47f3df36a3321743b0a9c02c3f847cc0a069edaab2c5c944"
    sha256 cellar: :any_skip_relocation, ventura:        "569ba7503c33613e1ff6caed59cef5497b8ca83e366e34303d4614bb73de9c96"
    sha256 cellar: :any_skip_relocation, monterey:       "d055c4a62a25aac293c0ec709a03b0269bd908fb53beddb908bb60a2b98e73a7"
    sha256 cellar: :any_skip_relocation, big_sur:        "61d44b4dca69b451a5f160e46ac374b0b686f9a6f6fcb327dc6532a0b4b91605"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a8ec83642a0628a881e8c278699d231d59f77c4d971d739f9880cc53d4f0a0a8"
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