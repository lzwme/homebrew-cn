class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-41.73.0.tgz"
  sha256 "d58a68d2e35d6f3718892de860d3916cf41c620dc82489a91d916ef021dd8527"
  license "AGPL-3.0-only"

  # There are thousands of renovate releases on npm and the page the `Npm`
  # strategy checks is several MB in size and can time out before the request
  # resolves. This checks the first page of tags on GitHub (to minimize data
  # transfer).
  livecheck do
    url "https://github.com/renovatebot/renovate/tags"
    regex(%r{href=["']?[^"' >]*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
    strategy :page_match
    throttle 10
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ae668f84451478b7452c2f0aa6478d0ae95e19958f23b1008e4ccd84f202a187"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "39ba210b72f7748d12e4288eb192816c03c768202808d83e0a4e1ca35837afbf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c0acb028781d08f22f74fa450b0f41a51ff0a35ddb96f220e39be2ac75e89a92"
    sha256 cellar: :any_skip_relocation, sonoma:        "ec57d8970a57f1e64c49396ff241aa7219ed54315559876ade034f0e444fdaf7"
    sha256 cellar: :any_skip_relocation, ventura:       "88308dd089bbd863c007d213b83cb771c21e425a4dfa03a25d4b285e023f544e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "979cf29f35adb78837a5522b767e72420f5c635fa48b96571ef61a2b5c0fc5ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4b08e8ce840434776fd420a5dc826e3c4ade90e0ade983721cba962e597dd6ba"
  end

  depends_on "node@22"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"renovate", "--platform=local", "--enabled=false"
  end
end