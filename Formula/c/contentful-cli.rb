class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https:github.comcontentfulcontentful-cli"
  url "https:registry.npmjs.orgcontentful-cli-contentful-cli-3.8.2.tgz"
  sha256 "7ceda8337730c358fed026594b7129454a876bd2f6c61f67c569e14a8391d7be"
  license "MIT"
  head "https:github.comcontentfulcontentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c9bdbf4c98a89a12c3719732b856798dbb281e75f8bf223e22e1884e78a0ef58"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c9bdbf4c98a89a12c3719732b856798dbb281e75f8bf223e22e1884e78a0ef58"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c9bdbf4c98a89a12c3719732b856798dbb281e75f8bf223e22e1884e78a0ef58"
    sha256 cellar: :any_skip_relocation, sonoma:        "d1777a31f6b2042ed0e71ac0378b127da0970ecf3c09fd3d8435b290bc67d542"
    sha256 cellar: :any_skip_relocation, ventura:       "d1777a31f6b2042ed0e71ac0378b127da0970ecf3c09fd3d8435b290bc67d542"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c9bdbf4c98a89a12c3719732b856798dbb281e75f8bf223e22e1884e78a0ef58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ae0befba0c24c9a9f40b6c17b48e00b18f73068e0739fb6b4a50ee9daa5794d"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    output = shell_output("#{bin}contentful space list 2>&1", 1)
    assert_match "🚨  Error: You have to be logged in to do this.", output
    assert_match "You can log in via contentful login", output
    assert_match "Or provide a management token via --management-token argument", output
  end
end