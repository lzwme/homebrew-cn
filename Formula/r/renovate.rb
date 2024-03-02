require "languagenode"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-37.222.0.tgz"
  sha256 "e6bf539f6159c68205f7818d2f7d8af3d7a5a9cdb3412482b3edfb061e28f95f"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0e15e8fbbfeae645da95c62d2d3822baa6f74cff8c29873f10f0a0dc8ccf266f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a284c19b65730a886927c836ea9ba3b82c0e8189eb841905cf44c3e4fde194f9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f4943cef7d854538bdb29c6673801e1dd69e35c51cf18d7f4b0cbbfaf9668876"
    sha256 cellar: :any_skip_relocation, sonoma:         "3144826032ae0e2af10477dc0736c4f46ef86b0cd33d9227f9097339282041a7"
    sha256 cellar: :any_skip_relocation, ventura:        "82353116784325c307f5a4e188b008505839b1e0a49976b125ee48b4e3ee93e4"
    sha256 cellar: :any_skip_relocation, monterey:       "9ba6dfa7fc4f2a5c099def1596ed6173cfe60cd74f1b0b2e067e15d3e5f629cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a2b1a086b8e8d86d2660ca00adf097b65a17212e717c4619a8b01d7ad53cfb11"
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