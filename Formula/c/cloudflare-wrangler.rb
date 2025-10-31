class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.45.3.tgz"
  sha256 "42ae9ea0e1f41de32b7e6c9a46038ac0a17c49156f4a2f1b3f1fc2d9fbd3ee2e"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "fc6bbc58e28266f6351f8bb34e0af71f99c8d3d8555e5dca61a9f28c0e3d24e1"
    sha256 cellar: :any,                 arm64_sequoia: "16e97ee1275b7832ef5216ef4904b6d4c055a5bac89efe43cc1a406c3276e446"
    sha256 cellar: :any,                 arm64_sonoma:  "16e97ee1275b7832ef5216ef4904b6d4c055a5bac89efe43cc1a406c3276e446"
    sha256 cellar: :any,                 sonoma:        "251ff2d5977386da5915424dc6dfe5484faab943b66b73ad4c183c0a4b54b48f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7ff7b609deb2bd1c001eccff46fa098746fe8921425219473b216b59667fe7ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b517b14c0dd39b9d8430866ec0c2ab734077d1420ccd5d5fb4ba99caa5c4be2a"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/wrangler*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wrangler -v")
    assert_match "Required Worker name missing", shell_output("#{bin}/wrangler secret list 2>&1", 1)
  end
end