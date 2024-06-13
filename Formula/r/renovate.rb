require "languagenode"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-37.406.0.tgz"
  sha256 "5e51506bdd8991226b068e99d9fd88ad04571856bd32c2528614dfb66bb5be85"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e4cb4c8f03c079958d5d77108ea939583f542e89b2c935b03deb9fdbe3ae8425"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3e00545bbf83863cdd4cf024c405a4d96ff58d378ba2efcaaab437c3750ff61d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e9b6b004a80f5bc24d84e480f9424b5216df203e77234f9187ef634140083458"
    sha256 cellar: :any_skip_relocation, sonoma:         "ccee260ccda585d03374346926d9bd1adcd081a5b01b3392e7b50fa1af60d155"
    sha256 cellar: :any_skip_relocation, ventura:        "2e819dcd021675591899d051663bfe9703bf66c8d1908080bc8169fdb5a923ba"
    sha256 cellar: :any_skip_relocation, monterey:       "0fab63c549a5f7333568298fc6f8bfddf5e081bd5acab533bfd2b441c6d8bd05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c87a494a3691f4caa84c93ad50568e136f5e4442125b32851030e2aeac0f4cf"
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