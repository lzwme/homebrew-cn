class CloudflareWrangler2 < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https:github.comcloudflareworkers-sdk"
  url "https:registry.npmjs.orgwrangler-wrangler-3.78.12.tgz"
  sha256 "67927d4057c69aa9293806b419c7c243a9cd16ad73f7af83d4cdd258e4a4ad81"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "908dc481127f130d670b776bc55b7421e2fdb3b3342167d8bff111881dd78bb3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "908dc481127f130d670b776bc55b7421e2fdb3b3342167d8bff111881dd78bb3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "908dc481127f130d670b776bc55b7421e2fdb3b3342167d8bff111881dd78bb3"
    sha256 cellar: :any_skip_relocation, sonoma:        "fbe22eda3b212daac65524f90b582a6c796c85e0149ad589e4d1e99889215390"
    sha256 cellar: :any_skip_relocation, ventura:       "fbe22eda3b212daac65524f90b582a6c796c85e0149ad589e4d1e99889215390"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3a6defe41e04232a8ffc8b076b8e3c37a88500b570614922754bc8942ba606fd"
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