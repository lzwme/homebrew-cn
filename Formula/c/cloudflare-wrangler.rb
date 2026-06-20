class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://developers.cloudflare.com/workers/"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.102.0.tgz"
  sha256 "f75520bd049f8527b91a6efee9e63c4095cb0865135ab626799a8566e7aa5827"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "7810468fe5d576608c4d04bb55ecbbce2317902d752877220d2dc40822ed0793"
    sha256 cellar: :any, arm64_sequoia: "72c0a444202bc76428567703c90b87e83128992e9abba4b0913b27ea87bfb11d"
    sha256 cellar: :any, arm64_sonoma:  "72c0a444202bc76428567703c90b87e83128992e9abba4b0913b27ea87bfb11d"
    sha256 cellar: :any, sonoma:        "3365683252628003d42114a23f5626dbb79144bed7f5121ee25735b6bab4dc07"
    sha256 cellar: :any, arm64_linux:   "cc133087191238baf93c07badc0d6eed55f120c2d3570acab4c17b750a102c30"
    sha256 cellar: :any, x86_64_linux:  "fa332f88680af4f21990891a1c7f16a075a9291f08c22924ba59eb080d9a6ba5"
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