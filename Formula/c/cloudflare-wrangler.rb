class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.80.0.tgz"
  sha256 "8d61bc7d097173c8c516bca36aff6faff58e739296b4d0b5b159a3698c383b70"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "078a0e129498d1f73d11ca48eedd7e6f25184e9466903724b82be89c5fe8f51d"
    sha256 cellar: :any,                 arm64_sequoia: "9ad5325ea236cecec3e65d633bcbc67f792617b42f21f619df66dc3bfba9a851"
    sha256 cellar: :any,                 arm64_sonoma:  "9ad5325ea236cecec3e65d633bcbc67f792617b42f21f619df66dc3bfba9a851"
    sha256 cellar: :any,                 sonoma:        "0e9961d53037a4a376109d7ac61f2e5b33b749f8c308d9788cb5463ca761d791"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b9d0774672a7bf82ffe7c7d7113d16846f936a434983a9fb3f098089f06bd7ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "af787c8753ef19d6248ded3dcb75595e14b98bc03e94cd7f150a7db8931c1da6"
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