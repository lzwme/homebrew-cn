require "languagenode"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-37.287.0.tgz"
  sha256 "7090f171ed507f8645978dd5f7f9d2f56629938411308da583f6027f490fa329"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3af9ed5bef004e251b189d371f03f6985fb66b1aa021dcf5ad785a907f17d654"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a77a05bd9ebb1e96894234b498b95406a910565fbb4dda00095eb44f101063bb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0360dd1ac9d17c21bf785f41e4602bb41e3abc1fe6e07c98216383ce29d7efa4"
    sha256 cellar: :any_skip_relocation, sonoma:         "9448fe5de4cfe160f15622a6352cefd63505a35cf4d8271ddf1c899990d927cb"
    sha256 cellar: :any_skip_relocation, ventura:        "f52e554bc526f90c7cdfea3f02acdf2128083973efefca45df00ee713f68ebfa"
    sha256 cellar: :any_skip_relocation, monterey:       "6f0f8faaef30b1d2661e033be99920644927ae87ee7caf188d6e4441f4478747"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "43893557fe14e9135fb899aaa51a8828bcd7ae6c408bf542f599120bf6af2196"
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