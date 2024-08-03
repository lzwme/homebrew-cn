class CloudflareWrangler2 < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https:github.comcloudflareworkers-sdk"
  url "https:registry.npmjs.orgwrangler-wrangler-3.68.0.tgz"
  sha256 "374a128e48f9455320de285d5ca95a40abc40c4e2bf5bbea7a86bd3a7e3c62dc"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "72755142fec8a8fbf9631a73299a8c4229620426188f2e7dbe461e3569ac90fa"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "72755142fec8a8fbf9631a73299a8c4229620426188f2e7dbe461e3569ac90fa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "72755142fec8a8fbf9631a73299a8c4229620426188f2e7dbe461e3569ac90fa"
    sha256 cellar: :any_skip_relocation, sonoma:         "d93b768b08c9fc7c5d54adba79b2692b9363a1c40af154cc1201da12c1b78171"
    sha256 cellar: :any_skip_relocation, ventura:        "d93b768b08c9fc7c5d54adba79b2692b9363a1c40af154cc1201da12c1b78171"
    sha256 cellar: :any_skip_relocation, monterey:       "d93b768b08c9fc7c5d54adba79b2692b9363a1c40af154cc1201da12c1b78171"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "335f2332202348a7f2b951853cb8c2610bf590550befd70fa3a24f365cec8b53"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}binwrangler*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}wrangler -v")
    assert_match "Required Worker name missing", shell_output("#{bin}wrangler secret list 2>&1", 1)
  end
end