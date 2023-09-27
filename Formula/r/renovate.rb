require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-36.108.0.tgz"
  sha256 "3290020d3b5f56448a6fe8cdd89cab5e76675f0e0a5afdf706921bdc892287af"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "aafd158f192eda32ebf1ed7dfbc84bca08e9bd0d9ae0999514f83717c1fb519c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8301c9af52189f141f86f7bdf56ded6ee3c9bcb7fd481fa531c4a919c09364d1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9319b74d3b985403000d8a1832c4f1dc71da7e35a7571836e7fd14e60e523c75"
    sha256 cellar: :any_skip_relocation, sonoma:         "29f32440fb6a1eb21bbfd3e3e9b6c0cffce85777b9f806de6fe9a02af490525a"
    sha256 cellar: :any_skip_relocation, ventura:        "9b34d22112c9ae76c5e1af27072cfe861aea10b5fdbcf9feffd3e03759ff3c9a"
    sha256 cellar: :any_skip_relocation, monterey:       "9d73a8b8689d501746c33ec86ce9c3582dcae6e97c62231d4971f42ad97a549f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "28be6e63c26944c37645f82462c0ea919afe3a88c8371b388ce01b7b372122ae"
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