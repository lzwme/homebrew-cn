require "languagenode"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-37.310.0.tgz"
  sha256 "f1e943bb11866a0c9c96819b06e7f29e6c276a3d94b89fdcb2e6c48a05f51da7"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c1afe027b3d31b1ccebf602cd5eaf51b53656f038c10f3bbac086c9c001cdbb6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a2c733cfa8e618bac31ea5c3224024725e9dacee0657ac24da442d4f788198c3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "95598cb27790abea95c07e373476766d6249851966355eb0d0624f4cccee7b42"
    sha256 cellar: :any_skip_relocation, sonoma:         "23285b40103016d609b9312d38bdeca5e6a2c8e5f95f8624e52edfc49f46159e"
    sha256 cellar: :any_skip_relocation, ventura:        "9a32ddd161a00ac80f2916954de44c1ddfbd844c704b03830c9c2477d1dc5d10"
    sha256 cellar: :any_skip_relocation, monterey:       "200ca413c91cf4cbaf3761e25512cb0442ad6efca2adfc8d52b0c0c6459c6c25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b79fa81c7dfa2d0acc37573065c8444ed429648eac0e0d67d9ae5327ecbcfeec"
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