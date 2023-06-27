require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-35.143.0.tgz"
  sha256 "b1d9772c35bc35f2297adcc96b538a83f14803cc97616afb5c9377ce13a20941"
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
    sha256                               arm64_ventura:  "a578d702eedf0971854cf6194907cc121ce171f48b4f7a07fc208c8ea7605634"
    sha256                               arm64_monterey: "2ba886c4ade0f0e7c5a9603aa98d5ab13f25a050f21447e955944022dc270210"
    sha256                               arm64_big_sur:  "4251707ba56f9575bff647e80209fb0d3253643fac4cbeb40710d04af6da1563"
    sha256 cellar: :any_skip_relocation, ventura:        "f351e7b6509b73ef011fc5b0a3aa6975738597dcfea7d882b8d7dfc1b8604ae7"
    sha256 cellar: :any_skip_relocation, monterey:       "a4179e9241729fc722e5206f459cb2b2ab00e7d3a26d1d19ad183378d88e6b5b"
    sha256 cellar: :any_skip_relocation, big_sur:        "b96b99756b608b18835a91cf53dcaa3bf2ed6ee9ae50e574416c53e7950b7077"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "20ef2585f525781f474992510be4156adbb52da8659e2cf75dbec6286ad8005b"
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