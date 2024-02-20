require "languagenode"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-37.202.0.tgz"
  sha256 "39d4adb311be5f74d4750a879327f2c76eba36a4aa92f57cffebfa53261a4014"
  license "AGPL-3.0-only"

  # There are thousands of renovate releases on npm and page the `Npm` strategy
  # checks is several MB in size and can time out before the request resolves.
  # This checks the "latest" release, which doesn't have the same issues.
  livecheck do
    url "https:registry.npmjs.orgrenovatelatest"
    regex(v?(\d+(?:\.\d+)+)i)
    strategy :json do |json, regex|
      json["version"]&.scan(regex) { |match| match[0] }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a5f37457d13e01709384aee824bc3a53f85f8d230b5005e20723f2144427c6de"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "398ad11e73f69db90ade930b2e966372021d6b7d356661b861890c18b8a4fc3d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7e9082335a27f955f622774d4f7f8676af40d74b13df157d04dde167f7cb4415"
    sha256 cellar: :any_skip_relocation, sonoma:         "1ccabfb3398f6cacf93db9c3a1a6d4fb988ae3566f4ce6a6f860b01bb2f60c65"
    sha256 cellar: :any_skip_relocation, ventura:        "f706c7e48c7bb917cd51e337cc5aa7041c2ce8c02eede18e26369ecec6271a49"
    sha256 cellar: :any_skip_relocation, monterey:       "b284e8f9ba982ca968c0bea480474427304bfd601b868d635643ece4d11fcac3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f9eae52e89a2a91b015854fa23b040550cf7ccda5352f4753ebfc1bf3fbf8e59"
  end

  depends_on "node"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    assert_match "FATAL: You must configure a GitHub token", shell_output("#{bin}renovate 2>&1", 1)
  end
end