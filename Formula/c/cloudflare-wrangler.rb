class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.74.0.tgz"
  sha256 "a2344b1e764186bc560c990e647ad5305696dd2985698ede438119bb33cd4f09"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e433aa87174e52808ff5d04874b4c856a6a8a598dce4e86d67b4bf111a833f15"
    sha256 cellar: :any,                 arm64_sequoia: "373a2b6a2ff691468db8f78ff0f5325693cdccbdef2ea58453b5d5912cb9262d"
    sha256 cellar: :any,                 arm64_sonoma:  "373a2b6a2ff691468db8f78ff0f5325693cdccbdef2ea58453b5d5912cb9262d"
    sha256 cellar: :any,                 sonoma:        "733e86bff926e8100a92c197110854c07b5eb3d21a88f9a5242c81684112f8f9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4c64143b93e516e367a89883d99e310771addbf5e3e16c229594e8c4a590cb1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "02d0da8a5734f6bbbf3a4b1d9001acf16e2c20df99e502b6b36ec35b5144471c"
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