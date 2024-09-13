class CloudflareWrangler2 < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https:github.comcloudflareworkers-sdk"
  url "https:registry.npmjs.orgwrangler-wrangler-3.77.0.tgz"
  sha256 "50479f01a0d936709197c0dde0558bce19e80e408af5cbc807491f6f60bd4ed0"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "3bd389c084240fcd439ab3b590f983743f5d43e5e1c537a21e41fc2cee0afd24"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3bd389c084240fcd439ab3b590f983743f5d43e5e1c537a21e41fc2cee0afd24"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3bd389c084240fcd439ab3b590f983743f5d43e5e1c537a21e41fc2cee0afd24"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3bd389c084240fcd439ab3b590f983743f5d43e5e1c537a21e41fc2cee0afd24"
    sha256 cellar: :any_skip_relocation, sonoma:         "89581ee47391dfb5f73f1f078eb52276e7af3f6894682073f32c28d817b37037"
    sha256 cellar: :any_skip_relocation, ventura:        "89581ee47391dfb5f73f1f078eb52276e7af3f6894682073f32c28d817b37037"
    sha256 cellar: :any_skip_relocation, monterey:       "89581ee47391dfb5f73f1f078eb52276e7af3f6894682073f32c28d817b37037"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3a8d85502bce03360eef57da94d4bec782e8b0df8bc343e1ff961975c4970053"
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