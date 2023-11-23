require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.65.0.tgz"
  sha256 "c3d3b30d3f272801968720fc7f5aa2fac0a076208a3ee1d9ab208232a21e3414"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "430ea439b9908197f1c47e25a54c4473f52061a67306ad750ab5301765a92dde"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fafc3797b61d90df5bafe85718ce9ee2fbfcb72e20c73c29e5718d4ecdac7320"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "baae6c450c743c62e926dfba881385e6b6031d332d3c94dbecb191eefda5e0c3"
    sha256 cellar: :any_skip_relocation, sonoma:         "9b109793356a98cbf840cd593c101a71c9c062f1d662e6d3266d44905be7b905"
    sha256 cellar: :any_skip_relocation, ventura:        "2f7671235c8d945e1941e50a7f69b4f933b0eb4ce69e18cf793d74b11f1794cc"
    sha256 cellar: :any_skip_relocation, monterey:       "7cf37439123f4fa0df6972f9cf2dfb4cef960b93be4dca51ca89fc047f629d57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "36087afcf543e3d7233d34fd62c969e325a4fb7a53a99c036ffe86653706dc85"
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