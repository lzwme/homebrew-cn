class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.0.23.tgz"
  sha256 "575b503168c525f93a04bebee6114e22521be705a80031d8dc58fd035990cd93"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "1a456092a55f4aaf698a3401ff03d82459ebd4102349ec68544fba8b02a28b12"
    sha256                               arm64_sequoia: "1a456092a55f4aaf698a3401ff03d82459ebd4102349ec68544fba8b02a28b12"
    sha256                               arm64_sonoma:  "1a456092a55f4aaf698a3401ff03d82459ebd4102349ec68544fba8b02a28b12"
    sha256 cellar: :any_skip_relocation, sonoma:        "08a9a6167b8b643c514f1325509349fb11a3cd1fce199b35bb7184f22bf7b244"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bb5925fb1240d2f071a401eaed7f209a01070f298870577454961eeda0876859"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "41cedca672a8f7e0c7ed0a181963bdae4f16d88eac97050b304f0f273a29ebec"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/opencode --version")
    assert_match "opencode", shell_output("#{bin}/opencode models")
  end
end