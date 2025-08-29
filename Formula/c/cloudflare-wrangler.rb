class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.33.1.tgz"
  sha256 "283c5fca69a03e698debb406b2075bde7830a531ee8040fa14a3dc74c9a4f2e3"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1def5eaf56f5aeec4a9bd07fc26ae748a6b66e5da64c2807357ef0428b3723de"
    sha256 cellar: :any,                 arm64_sonoma:  "1def5eaf56f5aeec4a9bd07fc26ae748a6b66e5da64c2807357ef0428b3723de"
    sha256 cellar: :any,                 arm64_ventura: "1def5eaf56f5aeec4a9bd07fc26ae748a6b66e5da64c2807357ef0428b3723de"
    sha256 cellar: :any,                 sonoma:        "00b6d8e3ee0bfa3f89db2bf65be37a6204480b1f06dc11597f3af39c14b0713e"
    sha256 cellar: :any,                 ventura:       "00b6d8e3ee0bfa3f89db2bf65be37a6204480b1f06dc11597f3af39c14b0713e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "321ef661de61396bbfa7f48a35cbed252a5c95d2d9109202ef7f5e4c64586a0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "890fa9028e632ed8b6e5a0dd3bba67e24ab10e548ec22332f60c3c50ee25ccbb"
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