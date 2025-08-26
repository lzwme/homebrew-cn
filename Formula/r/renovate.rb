class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-41.83.0.tgz"
  sha256 "d213fde51aedebb46b85a9c4140bc878128d3692a1f013b6580435724f8229ad"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d330b14b5618395233f11c3a80c1f608a9f2ae3d925a61b832bd1beb221c1c66"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e2be8a89264946df239ff2fc97dbaa0149b5633d28eee5782acf31dd9ad36a6c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "674f659d951e0384e1ea025b6d824ec803a23453af578cd48959e82bd225f880"
    sha256 cellar: :any_skip_relocation, sonoma:        "91eade2ad458172b5af91f34f879416aa359ccaa4ab26ae6d104933ad13e1a16"
    sha256 cellar: :any_skip_relocation, ventura:       "0b0302884db0276727c56f609d2a392f17cb3685532cec045ff866c407d439b0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d8de007a7599fe92407c2b96b2db0aba2812207b82d81847f75bc6dd3d1bda58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5204499fd8f7e70cf97463612ff9750e00b5bf04184af27cddad3de710753655"
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