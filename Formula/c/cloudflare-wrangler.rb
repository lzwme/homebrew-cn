class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://developers.cloudflare.com/workers/"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.129.1.tgz"
  sha256 "654c0a5c0a69a77f8fb40701d8806e0273e967de52693932829705dd66387ade"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "e627d543eced693857d8b54de7fc98db2a4a9626d123b54ec07c2ede49f8339e"
    sha256 cellar: :any, arm64_sequoia: "e627d543eced693857d8b54de7fc98db2a4a9626d123b54ec07c2ede49f8339e"
    sha256 cellar: :any, arm64_sonoma:  "e627d543eced693857d8b54de7fc98db2a4a9626d123b54ec07c2ede49f8339e"
    sha256 cellar: :any, arm64_linux:   "628ee46061a3d12aa25f6b521362ea016d1cb6795933c3dbd882da479784d442"
    sha256 cellar: :any, x86_64_linux:  "aead8199e763ff632f84d3120b472360f9458a80368f6088b3d0a88fc4ea3120"
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