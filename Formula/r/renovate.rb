class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-38.100.0.tgz"
  sha256 "ff9d116959c3db18217c5692fe0605f1e3d8264c4630cae4e5dd3c57abad8a32"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d26f3cef968c876202989ba960a11ba12bcbbcfef3295dc917e6776f751bfd82"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ffbef56df4e535e1327213d340e818d53d5e2a921e107f38b89069661ac12b26"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b42d9961f8c42957b90a470827a04f6e514592a169dafa87b268c31242ebd99e"
    sha256 cellar: :any_skip_relocation, sonoma:        "e69667325ea1248334fa8ac36a21c9078358d4b9141bbe13c379f41197b98d14"
    sha256 cellar: :any_skip_relocation, ventura:       "f33a26ccf7843ec871322dd44199136a72cd0abde66a71a7345ddd6f5ef839f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5831ba6a24ab446e88491255ecaab8ed76b0d3f4325e8cd7f27133a844ef1ff4"
  end

  depends_on "node@20"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    system bin"renovate", "--platform=local", "--enabled=false"
  end
end