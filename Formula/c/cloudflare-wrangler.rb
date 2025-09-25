class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.40.0.tgz"
  sha256 "3a2eda0b4aeb8a5dcc9838bd4dc1e1fd8c8314bc8294543addae85f38086f211"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9365972e27460c797985a6e77a962bf9c31ec1bbd128d29f84dda660e9884dfa"
    sha256 cellar: :any,                 arm64_sequoia: "7d7221eba8b12fbda307c350241d837a383a5eed510dac5e35e35a728d904696"
    sha256 cellar: :any,                 arm64_sonoma:  "7d7221eba8b12fbda307c350241d837a383a5eed510dac5e35e35a728d904696"
    sha256 cellar: :any,                 sonoma:        "1287b309d0d5eefd7a7197c048a92c7de55bf6d90632b29d2dd325e90946de85"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1880977ee6f208d77370db68cd98430943a4195fc8bc25b08c2adb362aa30513"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "090c58a06a7e2ff4609720f5741d68d16a2a570d6c917d4e2bb86fb8bdbb6caa"
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