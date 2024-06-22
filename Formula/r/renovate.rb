require "languagenode"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-37.414.0.tgz"
  sha256 "d1b30cf266a2b32f036b88818f35437f214ccf4a084b7786da256bc7626eeabb"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "741a145af94fab6f55cee34a0783fc5af22a2896d0bba189426f06b86339909d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "484eef07a40f759c8882b317c8145b77ea49d126f0fb5833c13f354578c11f19"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6deae1cfee78d70937df180c1e9fff1be09ef3016103c33f898d3860dc84d430"
    sha256 cellar: :any_skip_relocation, sonoma:         "669d3d9456b1b18eba67230808eeeea367c1532662d280edf5ec18f24f4e9cd3"
    sha256 cellar: :any_skip_relocation, ventura:        "96c8739fa8c12e0e8ceaa82cf12df6ed03eb50449f42b47e702f4299c251ef0e"
    sha256 cellar: :any_skip_relocation, monterey:       "776036e004df8f055e8991bb32f0b64d6172cd0bb02ac9bb94d26d668bb17c54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "888692129d487bd713c77aceeaf8286cfee796271deb800b0c2eabc1ffa365aa"
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