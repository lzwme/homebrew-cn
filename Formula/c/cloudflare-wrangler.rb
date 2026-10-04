class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://developers.cloudflare.com/workers/"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.147.0.tgz"
  sha256 "c42d210fa19f6e40b63a8df3b127740136dffe7525ee9ed82b8ab183d2cd8395"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "ab9b735301fb82e0f1dff00464c85d4becf1ec87f640aefe093b60fa877030f4"
    sha256 cellar: :any, arm64_tahoe:       "ab9b735301fb82e0f1dff00464c85d4becf1ec87f640aefe093b60fa877030f4"
    sha256 cellar: :any, arm64_sequoia:     "ab9b735301fb82e0f1dff00464c85d4becf1ec87f640aefe093b60fa877030f4"
    sha256 cellar: :any, arm64_linux:       "0451baf43927e71288580b19a4a45e15fd53dfd026b53ca7f50b2fd3de74713a"
    sha256 cellar: :any, x86_64_linux:      "db53de25c59a88bdceb364355da4cb69d0ba70f0e97fa8988ad6a3f5e4fe1b77"
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