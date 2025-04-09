class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https:github.comcloudflareworkers-sdk"
  url "https:registry.npmjs.orgwrangler-wrangler-4.9.1.tgz"
  sha256 "2a4636a83a3164dd610289da6d6e21569dd1109fb73a4525a21addc03570a4d5"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e6b8eb71048113e89a77c4d38f86efeabc4d0a3ff72309b766d056c411792586"
    sha256 cellar: :any,                 arm64_sonoma:  "e6b8eb71048113e89a77c4d38f86efeabc4d0a3ff72309b766d056c411792586"
    sha256 cellar: :any,                 arm64_ventura: "e6b8eb71048113e89a77c4d38f86efeabc4d0a3ff72309b766d056c411792586"
    sha256                               sonoma:        "f562f6ba6756e1918e16b2f8d7ca4c8cd17d36d812adf34efa3f85093e63b6c2"
    sha256                               ventura:       "f562f6ba6756e1918e16b2f8d7ca4c8cd17d36d812adf34efa3f85093e63b6c2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "119e745a97ea91f6478f22305959d332de36ab433abed375daa36aaff3bc160d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d82385d1a199df74cf2c8b25002cb1cc9486fb5e5d58e5d97d0f4b8724acc395"
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