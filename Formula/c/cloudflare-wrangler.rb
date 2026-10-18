class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://developers.cloudflare.com/workers/"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.151.1.tgz"
  sha256 "3be0437c17ee799f526c6b07246da59ebb57d17327fa4e275d0953881f1dbc65"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "df12e3f18f1b292445fffdab9f9455dfdf58d75ac426c8e5cd2390c7a8954118"
    sha256 cellar: :any, arm64_tahoe:       "df12e3f18f1b292445fffdab9f9455dfdf58d75ac426c8e5cd2390c7a8954118"
    sha256 cellar: :any, arm64_sequoia:     "df12e3f18f1b292445fffdab9f9455dfdf58d75ac426c8e5cd2390c7a8954118"
    sha256 cellar: :any, arm64_linux:       "ba4f1a5bb6337b5738e2b9ff52d8b33b3016ee7ecb190313a62746355e2d8093"
    sha256 cellar: :any, x86_64_linux:      "cc28798dc42cc6092114a71ca983a3dba174e100a9368f1f4f1559b9c29aaf0f"
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