require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-36.57.0.tgz"
  sha256 "99b098b42bddaa5e03aae42b5fa46192c69e8f480f1cf5d6f91990f8d1e5ec61"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "41bfa6e54df1e0bb66b2a4c9fffc16ed9f96c472308d0aec0154581089ae7645"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "010659ad5bc31be881cd41a2dc9aa959c63cc5ce182e4ed680ee7913d60ca104"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7cb7ea6b999e8e812b10e624fdc788b799aadeae4cac4306caafb361ebba9f0a"
    sha256 cellar: :any_skip_relocation, ventura:        "6e76846f47c3ee21897a4b152dfe4b59d03540ff68a82964fd9cb6903b0cb99c"
    sha256 cellar: :any_skip_relocation, monterey:       "4f75f9b53d26760a360550d3aaceeea4425ec95f045a8a8b145bbe4e2c16fd87"
    sha256 cellar: :any_skip_relocation, big_sur:        "a282f80d60fa6c7e6a48964d3728a1dce846ecc9a5b7e44b916c3aa009c36f4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "80df33c3c66c7468f64037920810cc49ae3d4439c096519322e04d82ce1e2724"
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