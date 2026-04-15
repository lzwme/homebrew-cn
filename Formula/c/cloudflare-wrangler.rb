class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.82.2.tgz"
  sha256 "03a96188d6f018826a47965c9321f7b8b616435a98a322eba19372821e67f882"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "fe4f849365d34fd7ff66ba20a3e7e2112acd6cb9de243329bde7cf45dc8ccf50"
    sha256 cellar: :any,                 arm64_sequoia: "b8ded6d0e7338acf101c496393498f71facac4581d510615437dde1c3a263a05"
    sha256 cellar: :any,                 arm64_sonoma:  "b8ded6d0e7338acf101c496393498f71facac4581d510615437dde1c3a263a05"
    sha256 cellar: :any,                 sonoma:        "2d320733434075ee4810647c5c226b08df33995d3055e6fe9c9bd4d5b4683a49"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6f77015e4fd6286e731cbd3189e526cb6d1d1bab5595bc42f69bc7581bf8c24a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "62cd31454deccab0857628883cf69f7443a0f8ba22db33058438e6f7cb53e2e6"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/wrangler*"]

    node_modules = libexec/"lib/node_modules/wrangler/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wrangler -v")
    assert_match "Required Worker name missing", shell_output("#{bin}/wrangler secret list 2>&1", 1)
  end
end