require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.83.0.tgz"
  sha256 "3b1ec75b7a8d37075535440471c6adc87f3b9a248e29e8b6ef9688ccf680cda1"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9aefff54bbdfd9e4623ae8fdbfb53b4afcfc1a0daae560e2711325e53a573a8f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "02ebe727dd37ddd1ad9c6652a98396da058fe6d7bdbefd2ceb7b9da887b4e00f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cce621bd5e24c730b6040731e7a23aab410be57b61327e86ac4f91b88746c251"
    sha256 cellar: :any_skip_relocation, sonoma:         "28d6005b10ddb175bbb49a842b81dfb2e38ef901c4aad49a18dea92ca7bb9b1d"
    sha256 cellar: :any_skip_relocation, ventura:        "187868271f2d957be59d01c6fa2db0f4fe24cb65179c680d245125c46c453e07"
    sha256 cellar: :any_skip_relocation, monterey:       "c2aae818c9117abac48753d8830b4c9008a9cbd55f7125c03d4fb99b7ba6a85b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "65285dfdc9b810f3255b35fbaaedafb899481cd15518080ade1735a075509673"
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