class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.64.0.tgz"
  sha256 "2d378177c601c8ee04dfac9befc91b7d445f802842594f1a411ab0219cd66f2d"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f32b67b955a8b686b7c12847d7470688b2a892285d72eddc40a41b45b4ef33fa"
    sha256 cellar: :any,                 arm64_sequoia: "855d8a7555352fe17fe6ce7910979a7bd1594c3e211acb48426d9e663e13c60e"
    sha256 cellar: :any,                 arm64_sonoma:  "855d8a7555352fe17fe6ce7910979a7bd1594c3e211acb48426d9e663e13c60e"
    sha256 cellar: :any,                 sonoma:        "caf1d5272b93cf7650e8a3285d10154cf39988335bd8b8b8441ddbc3947c19e6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5245cc4e16ee1a3534afb65cd371b9470714e1e415d3ba92f8245fbebf368b3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b2da79b142f9e5fe0462bd2240df57182755e4ffc8bc75d50e2610c48e615cd9"
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