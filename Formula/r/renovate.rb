require "languagenode"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-38.12.0.tgz"
  sha256 "1cd27521ddd97146916f3204af9ee6bc14c90504ff25e2fd23488548fbeb22e4"
  license "AGPL-3.0-only"

  # There are thousands of renovate releases on npm and the page the `Npm`
  # strategy checks is several MB in size and can time out before the request
  # resolves. This checks the first page of tags on GitHub (to minimize data
  # transfer).
  livecheck do
    url "https:github.comrenovatebotrenovatetags"
    regex(%r{href=["']?[^"' >]*?tagv?(\d+(?:\.\d+)+)["' >]}i)
    strategy :page_match
    throttle 10
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f944fc5c221854a58bafb6fd09c18a669119bf58eb767f92f16f9769c36d857e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "95a78226888bb625592c1afefd742ecd4d487622d5cd0f5f5f69dd5fff385f70"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "157c92889df9aaad7dcb70cfb29fdf0dde8ff16313dd3489fc84a7f8e9cc71d4"
    sha256 cellar: :any_skip_relocation, sonoma:         "dc629eb842b7178d5c9df15a4952cf4136231304bc26fc12e540c1d50dc65ef0"
    sha256 cellar: :any_skip_relocation, ventura:        "03e0c758bdcae3c87b686c68f4a63cd958a255c4c4ac74015d3000dc36bf27c5"
    sha256 cellar: :any_skip_relocation, monterey:       "1c93284aa0d5a1a1a92d5ee114fea4ee864459f57a172790ecb6145d82228c62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6e71c5fd40d6d2f85603f8df2752fb6767d5849f467e2c78d6eee139e7905fb9"
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