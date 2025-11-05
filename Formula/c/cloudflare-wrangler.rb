class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.45.4.tgz"
  sha256 "33313b57c8e3d0b35428fd124eee4ffb0af3fd1cbc6793b58cd4474093ae41d2"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "823d7d6158e511a8d367e7d06d1dbca08f6da6b944551305f472cc8674de54fd"
    sha256 cellar: :any,                 arm64_sequoia: "49a119bfbaf17a29419cf5557315ccf889f84cf88768125415edc0acbb9f6a30"
    sha256 cellar: :any,                 arm64_sonoma:  "49a119bfbaf17a29419cf5557315ccf889f84cf88768125415edc0acbb9f6a30"
    sha256 cellar: :any,                 sonoma:        "d357c0d724fda33719bf7ebc52453120c2bed31f0e450967f986b1096d362b1c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "399bafc635ee8aadbf0e8f2f0cbeab87d126f8c687b6e84c490d9695ce6a9641"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e4604129ccebe8bf5cf734aa3b185f7c302631ec7d14fefc3e1d47e45c0fac75"
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