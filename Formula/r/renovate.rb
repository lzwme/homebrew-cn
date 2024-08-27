class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-38.55.0.tgz"
  sha256 "3c2c0c786b704ced43bb489d7e014c80eec649d1e76498df2493e79a23984bca"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f5e11369a3e2431208475f6eb4a8e824388bab6c22b33daf81dd85faadc96de9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "07423d58ed30bd888053a2c4047245e3086ee3fbe0a814db4fb6a263bc61571d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "758fb34f7eb7e8a7a8862b87339eacffa27d2d6caf0752ad5eda2c2b9ea8db04"
    sha256 cellar: :any_skip_relocation, sonoma:         "fd95d27a35c60e08591d65771bef12cd23d2dfa441a79503c5ec706b87796d24"
    sha256 cellar: :any_skip_relocation, ventura:        "1f7fccdb8a0a1595da5654779ae56d0d23c9f1dc18f835e8602784ba4a3216af"
    sha256 cellar: :any_skip_relocation, monterey:       "f646fc8334696a3f9aaeb8dcb94019495847faf33f0c010a5e9384939d726bc1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5dd9bea0ac46cb05c9f68d93ef7ede2c7f4c878d0157f53c10836bd40112a8f7"
  end

  depends_on "node"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    assert_match "FATAL: You must configure a GitHub token", shell_output("#{bin}renovate 2>&1", 1)
  end
end