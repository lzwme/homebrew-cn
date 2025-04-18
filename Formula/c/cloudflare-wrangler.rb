class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https:github.comcloudflareworkers-sdk"
  url "https:registry.npmjs.orgwrangler-wrangler-4.12.0.tgz"
  sha256 "e85bf10454d930018eca3e34b9bb995ab1907153848da4552e015ce115954568"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "45bc186d826176c32a68a6d215e84f1193ad54d7625c865fddaf1f48b30a952d"
    sha256 cellar: :any,                 arm64_sonoma:  "45bc186d826176c32a68a6d215e84f1193ad54d7625c865fddaf1f48b30a952d"
    sha256 cellar: :any,                 arm64_ventura: "45bc186d826176c32a68a6d215e84f1193ad54d7625c865fddaf1f48b30a952d"
    sha256                               sonoma:        "5ba1bba829ab4cf89148386e45718fa137613044b3a0637aa27a22ba64546edc"
    sha256                               ventura:       "5ba1bba829ab4cf89148386e45718fa137613044b3a0637aa27a22ba64546edc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "917c0f7ebec9c80e9ac024c377153614dcafaa32d542bfe1bddea91f23b57275"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "07f92e3846cbb8c25e4abab85145fe69f29f4274abdce7b0823a8b4325c29fa3"
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