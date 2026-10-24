class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://developers.cloudflare.com/workers/"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.152.0.tgz"
  sha256 "0937cb6f17b28c012f7d745c137c4e5c4135b81b2cde836d37022615c9d3d690"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "03cd36881e6a0949ed4f3f77d57223fe35ba1ec61fb862d7878f947084f1bb18"
    sha256 cellar: :any, arm64_tahoe:       "03cd36881e6a0949ed4f3f77d57223fe35ba1ec61fb862d7878f947084f1bb18"
    sha256 cellar: :any, arm64_sequoia:     "03cd36881e6a0949ed4f3f77d57223fe35ba1ec61fb862d7878f947084f1bb18"
    sha256 cellar: :any, arm64_linux:       "059f1487226566db3ef6a2e6edb60e50bfe2a104523a5b8ade763a628682f779"
    sha256 cellar: :any, x86_64_linux:      "73ce822bfe172fe03bc63033e19888f935c31fc076ed0c83459dae241a3afaa2"
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