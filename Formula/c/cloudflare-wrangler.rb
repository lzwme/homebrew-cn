class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.61.1.tgz"
  sha256 "9262a8948434af503d102ef08a38d5613bd32257ff1e6f1afe5cfd50f883f712"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d43eabaaa561caed0921aaf9c831f176be949a3394905508516915f540857c50"
    sha256 cellar: :any,                 arm64_sequoia: "75fee9ab1bb565331131599700e6f0f04e22230b3312ccbf7ac7f8e9ace62e82"
    sha256 cellar: :any,                 arm64_sonoma:  "75fee9ab1bb565331131599700e6f0f04e22230b3312ccbf7ac7f8e9ace62e82"
    sha256 cellar: :any,                 sonoma:        "3aba3cd72c38c73c801a463fa04c6fd6ff83ad377a8e6ebacb5096a2f4f33006"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4178ad3cd477e4b8f14ad653c3c635072b706b61fc3fa48e7dabd2359a7b2306"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f23cc4142fcef9109ddb58d811f38b8fe521f9b7db913a2b8f25f5c9d1d78c3e"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/wrangler*"]

    node_modules = libexec/"lib/node_modules/wrangler/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wrangler -v")
    assert_match "Required Worker name missing", shell_output("#{bin}/wrangler secret list 2>&1", 1)
  end
end