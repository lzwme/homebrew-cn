class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-39.186.0.tgz"
  sha256 "7af9907cfbb381aacc4b77977e39a646c8969c5e20c609bddec87ff66311b930"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "22159323143eb37663a3805b7991a62563470248d625fb4cc37439033a74aeb0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6d639a5d15a49263dfda9c3ebff2765fc6f2259e604686907ce17bc108ba6f4b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b7e34124758e49c212be5e362b411fbec745a5738afba121f3d55202c9a31e84"
    sha256 cellar: :any_skip_relocation, sonoma:        "0aae52984b258ca81d522b085bf083fd55136e98bc5939352618de5d2ab95c2a"
    sha256 cellar: :any_skip_relocation, ventura:       "e0621da191daaf9a133314f5f396e60649b727658183e1665bcf91bb2ed823e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1614c7a57f1683c5ec5f471d588dc535929e8aa6f96ce8881979fd5114035f8b"
  end

  depends_on "node@22"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    system bin"renovate", "--platform=local", "--enabled=false"
  end
end