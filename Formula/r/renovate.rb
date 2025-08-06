class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-41.53.0.tgz"
  sha256 "74fc295ae6f0f10becfed82172e31fcd72802f9f4be78ff9643e813ac8c3ca69"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "91b8119290336fa9847683b28e8a4cae589d61ee5ce2697e9fce0eb012d682ea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "69be88a27f801843c234203cd41c774eeb02fa044777637c041db87b311fda87"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "71afc03bafe00d99fbe831b3151af924c698a5536e3767cbfc468b30fd260a12"
    sha256 cellar: :any_skip_relocation, sonoma:        "1ed10237a5ec6bbb5cc0696ddcc4978c8e3e687b0fba69fac09b522c38872b68"
    sha256 cellar: :any_skip_relocation, ventura:       "0b278c5999917fd91e2a665de10184cbd260aaf905ae71f4fe1587cb8c57ca49"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3c07d78fa8cdbee9d2f3da601da95b0a5d2c09a38abfd1601e43111febbbd1c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2db1102cbeae0184ecf47c4be2126649408c6921719422e024ee93a5aeca3026"
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