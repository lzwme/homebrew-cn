class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-39.156.0.tgz"
  sha256 "9d0ca38954ea9e8254a487143a23a818b83be14db0016dfa65947ee7e292d0c2"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9f3bf69e712496fabbb775a43989b855a9e46d94995d896efabc815aaa24657f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "17ca75478054b62ae3c328bf4487be337a2d4d10bc17187e605166ea7cb9dc7d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e04752a980fc25af4f8d7505586c7a880f77c8669012b07d5dc6339333af93e0"
    sha256 cellar: :any_skip_relocation, sonoma:        "4ee5ed9dc4e1155ebe6226743a118e71b5074f672b74bcbbccdfd7e355441541"
    sha256 cellar: :any_skip_relocation, ventura:       "1af900ff82a27dc02e6cf406c9b1d7e76a614dafda1afdb20a76698ca0bc8442"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1c75a5096ef2c65a5da0186046506cf26f7df1507eee7dddc6ba8addd6c505ce"
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