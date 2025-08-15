class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.30.0.tgz"
  sha256 "20f0852bc4c842a747ac8b896c9e50b3653db41792d554b35a5be2cceab7aafb"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d90078a7d3348482a9893fcd98023a64a939f6192658e13ad406811e790f93b8"
    sha256 cellar: :any,                 arm64_sonoma:  "d90078a7d3348482a9893fcd98023a64a939f6192658e13ad406811e790f93b8"
    sha256 cellar: :any,                 arm64_ventura: "d90078a7d3348482a9893fcd98023a64a939f6192658e13ad406811e790f93b8"
    sha256 cellar: :any,                 sonoma:        "d99e9e55b0187f72a51a0d3581004f3dcd7b81f8ac7a293d8a5d2fd9904ccf4e"
    sha256 cellar: :any,                 ventura:       "d99e9e55b0187f72a51a0d3581004f3dcd7b81f8ac7a293d8a5d2fd9904ccf4e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c718c1491377f6de70c8425687f03def20f8d10f4199efeb7fbb40bcc22b1651"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cfab0586130c91eb5c151e9287c9546d8f4334b4a9f5e0098a4e7ff6512837a8"
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