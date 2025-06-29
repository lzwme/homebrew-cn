class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-41.16.0.tgz"
  sha256 "764faafcf77aaac8508694555ddea1db99a3f285162648fd3907998a21bf9538"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "35e3efdb8a2756514c48894da38170f88b535daa6694d6098804c445b40395bb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "723f54ed17d21040c604c9769111ce92bc063bcea9e9d8cc56b6e18a570f8ec9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "38001efc2845250e45a2e30fbbd1a28ba799a7974684cf168b88f2f9c3e76d58"
    sha256 cellar: :any_skip_relocation, sonoma:        "f94f527557596f4b6dbec031ec8c39e36d97fc582a3c7d4ce3dfcd53f5ed9d47"
    sha256 cellar: :any_skip_relocation, ventura:       "a393acdb749def459ae83c51fd21e5f4e96a44e11057145ed73b7940054b4e08"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6a1a060e3e66f99f14ab0c6d5a17e4494ba30c7cb0f57a96fcca941dae09324e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "112ac17c4b02ddff2d3bd84f98aa14c2c1f91493f5b9a9e77b58024a7ade5c71"
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