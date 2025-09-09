class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-41.98.0.tgz"
  sha256 "d384c48b1e6afeb04d7aec7108f6e9933ec181456d7b3d3b1456dc2293d15977"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d83ef07fee4538416bc21992d41e080535c34d965b18526ecb61175efa5eebdd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7d24dbdf48729afae296df5b85de37aadad4b0020f7c0b52d9564b9f474c4268"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "09b49b69180faac3893c53dbbaa60bc95f99b9e2b1fbad8af6851f75a7ada059"
    sha256 cellar: :any_skip_relocation, sonoma:        "7142cf3b51e3a00b4a1c80845969a95dad430092340697a365a583efb696b7aa"
    sha256 cellar: :any_skip_relocation, ventura:       "bfafc636b142f4a734a8e85a7e189833c4f624343ec1e9887873dcf514378747"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dffa9d0e073d612581af659fd9b169f58b1f5cc019a24c0fe108662052fec892"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c3b036b4c56cb05885cf903ffda122e7a08996222d62f12060a032c362012a82"
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