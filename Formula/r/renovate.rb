require "languagenode"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-37.274.0.tgz"
  sha256 "459750ca045eec58082bf96909de7659acece99934256d4de5ddc4f1c3085341"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b6c0661d6159a0a2ae6e2f60e1d92fec45053354119bcce68289d750c7f225f5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b9f01d569988c242bcc706d98830581383a24aeaa7040efc239c71292d52f2d2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c0fbe38f6f76602356db1601a44acbc7d954673614cdc0dbbc2d1706af903d0b"
    sha256 cellar: :any_skip_relocation, sonoma:         "a5f28c6577d40bb4c5163a99cc62dbcf3a5e0163a4b1686ba2d845cc00507887"
    sha256 cellar: :any_skip_relocation, ventura:        "513f651757aa1d358897afa3812dc0ae9838a3af5f605028ae90f21c9bd63a59"
    sha256 cellar: :any_skip_relocation, monterey:       "207173e8aeb7ac96a6427e774712478055eb184b3925e4cb866d3480e27e2dbe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ac089961928833dbfc27922fdc32477f72ea1e1eb5a150e08722ba54a26a39a"
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