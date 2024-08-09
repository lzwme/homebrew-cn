class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-38.23.0.tgz"
  sha256 "c69a74c4c28af68267e8201f76bc98e8de48bbe51ee94d7fa6be4811c3cb27f1"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "34f0fa4e8d5b1746ffd7fef37db2e78d018fd2b457996442a980c254bd97b962"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b36d5dee1bc59b0d77858e7757373231799dfa4a78d9cffce38189ee8176d2f2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f150fd1019f848f23bd5455bd43b5173b965eb9f30a1a1f98c97047db06b70aa"
    sha256 cellar: :any_skip_relocation, sonoma:         "5b195cc5dd1bcd1799914837eb276ca27912667e1e6454e5777e0d816126204e"
    sha256 cellar: :any_skip_relocation, ventura:        "4e2ad0fa5a60c2abe3fe6ca69b34354a148ac3cd0f42587e2af4a83efeeccccd"
    sha256 cellar: :any_skip_relocation, monterey:       "cf9a13f36c9f20d8aaab683cf9db7b2005846f636779242dcfa84b1746448278"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "540c0c296bac6b3112c8e71930734e8195f1be6cfcc417a0a5e3e27ad5ecb9f8"
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