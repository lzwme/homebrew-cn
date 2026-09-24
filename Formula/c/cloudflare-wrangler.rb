class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://developers.cloudflare.com/workers/"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.136.3.tgz"
  sha256 "306f2483ff7133cd3ef12e045e56fe22fe7fad30772274e1556b7de2b56eae0a"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "402c43556a0519978b69375a455ac577e4fbb91fa8dc7e89683561b5005519bb"
    sha256 cellar: :any, arm64_tahoe:       "402c43556a0519978b69375a455ac577e4fbb91fa8dc7e89683561b5005519bb"
    sha256 cellar: :any, arm64_sequoia:     "402c43556a0519978b69375a455ac577e4fbb91fa8dc7e89683561b5005519bb"
    sha256 cellar: :any, arm64_linux:       "14994bf847a041a0ec68277ebf25795aee9317c42859d61ebae2ccaae12245b8"
    sha256 cellar: :any, x86_64_linux:      "931e4db9ed3525621ec42432890c9314f9ff067a39934c8f04972aa84434e9f3"
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