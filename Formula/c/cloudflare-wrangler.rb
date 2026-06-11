class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.99.0.tgz"
  sha256 "e825b0407dcbb6a4291157e9b68bd6012ba5a1f2a8adaf328ab202f03b21204b"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "5d4eb2b0d2c04e9dd9f8e972ffab4046607ef54a94cef843d9dce02622f3d7dd"
    sha256 cellar: :any, arm64_sequoia: "541c76e814047a720a38589eedea5a391599899d5314caf32d203eb6ecc84cc1"
    sha256 cellar: :any, arm64_sonoma:  "541c76e814047a720a38589eedea5a391599899d5314caf32d203eb6ecc84cc1"
    sha256 cellar: :any, sonoma:        "35a5094b740c25f8e36e14b2f9692d2c7fa8f0ad3a2dcc926da14226fc5778aa"
    sha256 cellar: :any, arm64_linux:   "a2f41e24f302c0431a0aeafc026a19910de2b9b0b3bc39dc9f023d012e3103dc"
    sha256 cellar: :any, x86_64_linux:  "ed043d325628c5946a24e7885660808b823da88915fefe27d0d1cdae8820af1f"
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