class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://developers.cloudflare.com/workers/"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.112.0.tgz"
  sha256 "ea3a15df70cbf188b3d446dedd0a290537890a825f59e4c7c357cd8dad4dc98a"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "202053b0a907bdea9ea89f00466a909d8ded51c28672224121fd998cdfb5fda3"
    sha256 cellar: :any, arm64_sequoia: "202053b0a907bdea9ea89f00466a909d8ded51c28672224121fd998cdfb5fda3"
    sha256 cellar: :any, arm64_sonoma:  "202053b0a907bdea9ea89f00466a909d8ded51c28672224121fd998cdfb5fda3"
    sha256 cellar: :any, sonoma:        "9e9f194ff41aba19ff14198d89c76136db8b418602bae2d119add5f681d2bb7b"
    sha256 cellar: :any, arm64_linux:   "b3b33cc923de7834645a1dac56214d298d84d596ed4c5365081b02d7c0c64572"
    sha256 cellar: :any, x86_64_linux:  "54bec138f9e6e87e11f730fc40ba79458a4685c77d5d5d9fa8b705d8c556fa55"
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