require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-36.91.0.tgz"
  sha256 "961731ec3b6321f713e889e94e8b9152079910a68d6d18e11ca1669d3ab3b4e0"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "97111e8566c839940af94b9b693f3ddd4b01c819b2212590575520967591a9b2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1daf9b701f9d53f7ac455f997d276cefef301da3ccacbd185d7d07bb71799b46"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0352c9300ab23d11a8badc33124b818e3ff4a6c254993c46e09a5cc21728dd9f"
    sha256 cellar: :any_skip_relocation, ventura:        "a56302ef6fe167c382fe9ededa83848e023a273ab6b723372152506f9b81e038"
    sha256 cellar: :any_skip_relocation, monterey:       "72e75d89b28067a774d68ba57bb2589ff11bd75969707222421e7b98d7cbcd8b"
    sha256 cellar: :any_skip_relocation, big_sur:        "aa13cc59f0640566c44d4b0d92d7d555408aec9bcdb1787945600c709d72a10a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f7d705135b10f015473954bcf4c9c59c7b4c76c87b0e30f7137c2dd8b49c0c7a"
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