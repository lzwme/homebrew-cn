require "languagenode"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-37.415.0.tgz"
  sha256 "23eb3a20cf2275634c7027d88eaf395da95bb97bb1391e01f152dadfa105614c"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "97a5c123ccdad8800c178fbd4ddcf594a4883526c465a91b55bf8fbef045e058"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8a69d5ff243f587d07144caacdd975579dab27daf5e4303885e5160c1b858ad2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "38ab09c4b11d2c2ccd9a00e203ab8985c1b290e1187950d8c84df14c82b76656"
    sha256 cellar: :any_skip_relocation, sonoma:         "187c3675af58a8f0c9b1b76bcc98fc05bc0685c5a9d51ffdb7c53ef9b36f2622"
    sha256 cellar: :any_skip_relocation, ventura:        "27b0aeacf67d1254d13cdc1108a6055fb2215db04e74259cb13aacc23bbe7e88"
    sha256 cellar: :any_skip_relocation, monterey:       "c2f0716598c80558767cbae2abcd8ce8bdbd24c502468870103fec42bb03f1f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a7f902b057dd9c1b66134ec937dee3835086ad982560248b556689fd8c5a6e07"
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