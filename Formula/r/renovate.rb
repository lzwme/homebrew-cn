require "languagenode"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-37.431.0.tgz"
  sha256 "1f93da9463a7cdaf586989207d72b40ac973ee1909f0db69efc58a74df1b8548"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "56d55eb17c9f10107b1e561373b181ca6d9d40ae3bc3a9b0eacf81b4b509a3a6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c8395609ba8e470799a44e11737cf2e6a30c9cca8b90574c6fb2b5cf4ca96649"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cb954d24311a77b4395cb077f148d7dbd88ab0ff2273a17a3ca3d3bea1623310"
    sha256 cellar: :any_skip_relocation, sonoma:         "ba1874fb5144c09b6a7166aa1740b0db69dbd936018f6f002178d614166ef6d0"
    sha256 cellar: :any_skip_relocation, ventura:        "b9b836734570f5e3d9e69e6575e59266ff12ab72f4460c191d2c2568d5e585d3"
    sha256 cellar: :any_skip_relocation, monterey:       "360efbef36becaea3c952f8bcf579880a7b30afca809ba064b7fefc2ec73a067"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "90ebf1a505de9814f843aa7d7823caedd69121f0a389dc211f2cfa79b70ba4a9"
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