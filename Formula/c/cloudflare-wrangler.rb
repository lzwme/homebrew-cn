class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.69.0.tgz"
  sha256 "07bb8be1ed1d148a71e64cd42e57ccb43dae797f0882f9180ce00b3498c1d7aa"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a9f19ca31c3b9615f12781f75b42d6378d55782a9af38b05fb153bac29c0d94d"
    sha256 cellar: :any,                 arm64_sequoia: "042a6f97702957d731b7fef53c6ddeed71a4071a9765c84c394dbd0ecb1748f2"
    sha256 cellar: :any,                 arm64_sonoma:  "042a6f97702957d731b7fef53c6ddeed71a4071a9765c84c394dbd0ecb1748f2"
    sha256 cellar: :any,                 sonoma:        "e7027e69e5bece19ae9eb79a1cf6c8288e6e538eed4c30f152da8bdcbf16336a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b2d656dac650ebfa420e0140e7f4304d6c74853787e38428283723b8534eab96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "613b78203989061929f7f40304bf198e6af2951b4650b246700d3796cc1baa8e"
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