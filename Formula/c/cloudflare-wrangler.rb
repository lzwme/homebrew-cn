class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.97.0.tgz"
  sha256 "366e6ceb0133c8f5aa6a2d245626438522faf63e2900cbc262b3274a71b23b6e"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "220ae45ec020f2d1d0a1e4c37fb8812a447c69ebe96eba7859606b42070cfa4f"
    sha256 cellar: :any, arm64_sequoia: "b12bfb08edebe66e78a30f6e53ac1ce46502394615e706c07f75068fad4b0c9f"
    sha256 cellar: :any, arm64_sonoma:  "b12bfb08edebe66e78a30f6e53ac1ce46502394615e706c07f75068fad4b0c9f"
    sha256 cellar: :any, sonoma:        "c93cd58ee99336fb79796302d12f07b1b4a836813b110a34e5dbf1bd8fa43767"
    sha256 cellar: :any, arm64_linux:   "f8fa7cfd6d551c8c32d3b2261bcfa45d164819870af283c7df148b2ea46d628d"
    sha256 cellar: :any, x86_64_linux:  "2807f5bda74e0f5acbdec4cae1c441ba1abb707b3e27fa6cd000e4755a6ddc8e"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/wrangler*"]

    node_modules = libexec/"lib/node_modules/wrangler/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?

    generate_completions_from_executable(bin/"wrangler", "complete", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wrangler -v")
    assert_match "Required Worker name missing", shell_output("#{bin}/wrangler secret list 2>&1", 1)
  end
end