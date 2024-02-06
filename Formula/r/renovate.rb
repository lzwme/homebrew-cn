require "languagenode"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-37.173.0.tgz"
  sha256 "8958f29e2246e99250dc058421c3073948413d51fdaa7522f643c42cfac983ff"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dce2345ed07b950e25f7479f83a9be91cedb3436b0354589ce5a8ae6f4937937"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "02adf0e86d5825fc02076beab1de8bfae44157e2d50032715af5193545fc8788"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fc6876909f43d328af7a6927261e6fd49b0f67b20cd71d19f3a789c245e6d806"
    sha256 cellar: :any_skip_relocation, sonoma:         "4e281c2b769b5e0e9e87f5daaaa0dacdd1feb80532547349eda49b73cbb9bbf4"
    sha256 cellar: :any_skip_relocation, ventura:        "4b35bccfe0194428e241863cd75038538c40f001cfc5ef6c3ba868f2e5046282"
    sha256 cellar: :any_skip_relocation, monterey:       "124a56b1162ff4113db6edb8142f54ed257a92cceb5783b812fec54970ad2179"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "513459e4eec4a18a95f1d831e87975cbcb2c27642df98926dabd5bdc5dbd6332"
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