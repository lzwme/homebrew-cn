class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://developers.cloudflare.com/workers/"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.115.0.tgz"
  sha256 "002cb791205970ad3bd27e01249c5669667f4984cd9d51c993414be360f35e7d"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "bade3e10ab1c626eb9b85a521c939a847325228ae351ff44f77aa774aa81fdab"
    sha256 cellar: :any, arm64_sequoia: "bade3e10ab1c626eb9b85a521c939a847325228ae351ff44f77aa774aa81fdab"
    sha256 cellar: :any, arm64_sonoma:  "bade3e10ab1c626eb9b85a521c939a847325228ae351ff44f77aa774aa81fdab"
    sha256 cellar: :any, sonoma:        "3388fa492a1486a8099095d8b314f61c4d3a3a5701310a7756bda0ec1032b802"
    sha256 cellar: :any, arm64_linux:   "5113cc693e2dd0507cce6af22dde005c62e00dee20ce0990df64df839a28796d"
    sha256 cellar: :any, x86_64_linux:  "4e1aead9f7096608a6bd7510169c6b4cce51007ab1d9b01caa5e4a5f4f35cb2c"
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