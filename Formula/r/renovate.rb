require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-36.66.0.tgz"
  sha256 "d492dda3a14f8b2b458f5c19e9bf58dcfe005cfecba48a7291c62d02e94f80da"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f74fc953a2c02849080eb1263b7d56f987cff71f7f9cc8c518508130e09d67de"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "76d92538d16ce6a926ce9eee95903944bf6cec070c554ba1bbf6181a8f2792bf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "53c8fb0b8c981248ff9632e88e2c321a1adbefe7d9316bfaa691ab04f3023a7e"
    sha256 cellar: :any_skip_relocation, ventura:        "2bd30891bb2929bb738e9a0e5a0fb4cf1cee7d9104511b2c894a2e5f3613bb42"
    sha256 cellar: :any_skip_relocation, monterey:       "60df9b10eb441218e206ed7ad1e7064518b61664939c25842d65ac730d0af6da"
    sha256 cellar: :any_skip_relocation, big_sur:        "92443f87d0e943c09751198512332a2c513ac50add0c799599e51de90ecf7bf2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e73a15260b339ff4090b55013ae924a2df276836f1d003bbd166cf113aae2283"
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