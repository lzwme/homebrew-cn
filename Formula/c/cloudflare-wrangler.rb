class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.57.0.tgz"
  sha256 "3ece9bbe02987a716fd26022cf87a2385d8c199366a9bdde5e53d6e061c3056e"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0e51a209decfa33a7a5535a2c607cdb3369c93f8e703e22256f41b2725586a4c"
    sha256 cellar: :any,                 arm64_sequoia: "fa327baf8b6a4956b8f3cad5fcd80e9b7527e767a2a03b96eab3251ddd21849e"
    sha256 cellar: :any,                 arm64_sonoma:  "fa327baf8b6a4956b8f3cad5fcd80e9b7527e767a2a03b96eab3251ddd21849e"
    sha256 cellar: :any,                 sonoma:        "ef3bb9161decd89ecd0a97a841b2ec4961ce7fbbe375215b46aa6abc5d5a2035"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "609093e773e0f804ce7f6c8758d93394afe98c4510aa5f9ce95afa943062f5ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "96a9aa31fb2928823cf3dc88e7db8471a3d0ec37e13a4ed1d187a1b2d8a94c42"
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