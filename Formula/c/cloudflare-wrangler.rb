class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.45.2.tgz"
  sha256 "4f22648fad6517f79cf6f0b3fe49c744b571976469ce585c8ec87dc4f3288803"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0b4f5679b2de0d7650cdfa1d5a208dd3729e12e86eb119e4a567802956fdb4e4"
    sha256 cellar: :any,                 arm64_sequoia: "d5a2a3da88a7bd31a06c479d7e0785ad41590117b9eff079977e345a6eecdceb"
    sha256 cellar: :any,                 arm64_sonoma:  "d5a2a3da88a7bd31a06c479d7e0785ad41590117b9eff079977e345a6eecdceb"
    sha256 cellar: :any,                 sonoma:        "140fa1891cd4549ef858c3b84f6ee2d40350024c57f4201097c6b2dd999cf4e6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "04f0b7d3d90a70730f34dd13ae3205e3955f3aff532eb341ff9e56e7af02332f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4c6426c07c91769891e165ea98c378c3ab17579fce99dcd52a70190133c3ee37"
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