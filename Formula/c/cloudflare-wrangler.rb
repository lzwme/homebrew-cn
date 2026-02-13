class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.65.0.tgz"
  sha256 "6dd0e138e736001541e06b86114f1e11836bb1a7f75a3cb4928e6274783075eb"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1dee41855b7f0b7a32f87455a0b6036f9c128a3a7e75052f2b90765205b68835"
    sha256 cellar: :any,                 arm64_sequoia: "f47c59cdec02499d026d8648eb50db1898d7a7853a695982218579f2806fdedf"
    sha256 cellar: :any,                 arm64_sonoma:  "f47c59cdec02499d026d8648eb50db1898d7a7853a695982218579f2806fdedf"
    sha256 cellar: :any,                 sonoma:        "66e0791173f09e4c583676545b4e69fb0d66625f79d4284e6dc122831cd9aa48"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d4ae6e7387cc51115519c4a157bded69f30fb04bb06469f8f35786d243b92f79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e997c04af9e818fd95f5dff9d984caa9f478eef3a527c8adbb51a4e05db6fc8"
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