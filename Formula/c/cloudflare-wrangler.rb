class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.79.0.tgz"
  sha256 "8a0722e9cf91c104550e3a9e5343565b34cfd7f95f39eecc430e479c62747dec"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "661b68615486ecc3bd89cf0d61af3eed1ec7a9665ac08112ae87cab912f6e061"
    sha256 cellar: :any,                 arm64_sequoia: "6e74a0ff986676bbc562b04f9a0dfdad26bf01d582765e972cde704425da2da5"
    sha256 cellar: :any,                 arm64_sonoma:  "6e74a0ff986676bbc562b04f9a0dfdad26bf01d582765e972cde704425da2da5"
    sha256 cellar: :any,                 sonoma:        "362a939d0670fb087386da784bd01068bfb10fe0005c806b5981eecaa26c77b0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "864162408a992db54375a6cabfc678f99b15ff12f71cb35936995b019afb651f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b60cca1dd71a3c49e80caf0015a44dc8b8fd7f85f44010d0481a89c5319734e"
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