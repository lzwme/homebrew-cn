class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.43.0.tgz"
  sha256 "6271aa328c2bf7783a774d9979d0b349c8690f1752019d71e54eb0e727162046"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d317f67c89f316849e62ceefcb2c0bdc46129616b5e5ba69e399c49a05f0050c"
    sha256 cellar: :any,                 arm64_sequoia: "c84d8bfd70845169b61542d76c20a6c0df76eaf134a4914abd148321bcce18a0"
    sha256 cellar: :any,                 arm64_sonoma:  "c84d8bfd70845169b61542d76c20a6c0df76eaf134a4914abd148321bcce18a0"
    sha256 cellar: :any,                 sonoma:        "e3666616bd570cbd34a3454e558517cb8fce12bf44a49462cf7ca2804f63e20d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d1760ed18086227142a1a6fa8ee59ca5836cd593101da25f5accaec25b74991f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b69ce453178d7d512b64ad6e21e3f79249e188c2cd62ce592869e330fc91082"
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