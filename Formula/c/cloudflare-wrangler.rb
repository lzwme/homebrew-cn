class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://developers.cloudflare.com/workers/"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.137.0.tgz"
  sha256 "f39ad65a122b15acf74c38f9575dce6147810e308995909050e9e29668685ca1"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "6a0f0e3467c37863f66e297475b3aebe68c2da30faf6f0dd46939a22cfac6bee"
    sha256 cellar: :any, arm64_tahoe:       "6a0f0e3467c37863f66e297475b3aebe68c2da30faf6f0dd46939a22cfac6bee"
    sha256 cellar: :any, arm64_sequoia:     "6a0f0e3467c37863f66e297475b3aebe68c2da30faf6f0dd46939a22cfac6bee"
    sha256 cellar: :any, arm64_linux:       "9ca9b64f2bb10d4e5e2ba7807c44a0bef5506f250a6085b952995b1861652f74"
    sha256 cellar: :any, x86_64_linux:      "7a55f4e350e6aa7417ffef8ea090f88ae7d5e8fe4341f335638c3c102b7897df"
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