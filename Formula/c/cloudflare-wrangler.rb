class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.67.0.tgz"
  sha256 "bd6261a8b5ad1a84c11867c5d33c6253acf8d007a768fde9aab687cfcb696dc2"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a0a4055b0e71cb68b52dc88582fbd996ce4877fffc091c0cdded3af1cdacb046"
    sha256 cellar: :any,                 arm64_sequoia: "eb8d741063ff2cea16eaf52c7494e2b7f72380d4052e30c13ad6ede93098f598"
    sha256 cellar: :any,                 arm64_sonoma:  "eb8d741063ff2cea16eaf52c7494e2b7f72380d4052e30c13ad6ede93098f598"
    sha256 cellar: :any,                 sonoma:        "e4b31133b0dd45b3ff16502d7fb67341238ff414382caa7fbb08e03f534662e8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "371aadcc117e8c86af015d1dde7f16e1a2e053ccb17be0591642763dd61c4971"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dafcb9083f4cb46ca0df40d0cdeff949c153b15a7ec5ac8c1f770ff6e3490a06"
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