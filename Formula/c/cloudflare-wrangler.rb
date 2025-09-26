class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.40.1.tgz"
  sha256 "83eeb24662de297ea7b45526c4c63237599345b11e450bede1e1f941c5af1979"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "68a58301ca931e0b91211b93f1b696bab92b0c3206bdeea5436f03462039810c"
    sha256 cellar: :any,                 arm64_sequoia: "01eb61bdb28f9693db78b3ef8b224e868e8c9484a479702c74ff9b3a31e1e425"
    sha256 cellar: :any,                 arm64_sonoma:  "01eb61bdb28f9693db78b3ef8b224e868e8c9484a479702c74ff9b3a31e1e425"
    sha256 cellar: :any,                 sonoma:        "bba37f6b1c146f02d3c6548783e2ad73fa55699f127a25b5598feac2fdaf3f25"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bd45e5897f07aef603b7a7cc72bee3ab6d6435f05363ae68de082bf04371144b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b4a5eeb32cd80065a08c26aecd328335e64c0a8a5670edb2094b890ff0375bc"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/wrangler*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wrangler -v")
    assert_match "Required Worker name missing", shell_output("#{bin}/wrangler secret list 2>&1", 1)
  end
end