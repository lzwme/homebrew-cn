require "languagenode"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-37.381.0.tgz"
  sha256 "bd3d42fd63dac9db921c08214b0a2dc01481a31a86672cb7fe2f99e0890e21aa"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "79556567c86c4598ff2bf1c87402f792d93f1a68fff8813d6f622460415ecfd4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "862bdc111d3ccc9926c9310111a4fb4610c511b0a85514b10cc54000ec6337e6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8427be0591e5a791481f4242b470d42c8b5ee59b3e8619e1065b24f15002622a"
    sha256                               sonoma:         "1fc9f4004b6f38eaff96cfa0477893482c3bdf42bb5f035dd261a91868cde75f"
    sha256                               ventura:        "2429d0ec1c7e36ba7526f27a978668ac5e7a19e52c1cef7527aaef4df1454fd7"
    sha256                               monterey:       "e3370e1ba5cb9843b86e7233f1295a44c6ec3ac001f68ed21beea17454821b2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b2b5afdfea665258194e3ded42934268eb16ae84130d5d3d8b46bd35e1568139"
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