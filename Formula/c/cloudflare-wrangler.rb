class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.34.0.tgz"
  sha256 "55b8f6e90450c089d71085ca013c710b4162c62b6aa102da14c589501f2530e7"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ecd52114c8f3b510ab52a71883b79f3aae28f01b7c01e76fc5fe425e05efe068"
    sha256 cellar: :any,                 arm64_sonoma:  "ecd52114c8f3b510ab52a71883b79f3aae28f01b7c01e76fc5fe425e05efe068"
    sha256 cellar: :any,                 arm64_ventura: "ecd52114c8f3b510ab52a71883b79f3aae28f01b7c01e76fc5fe425e05efe068"
    sha256 cellar: :any,                 sonoma:        "c8f7beb8652aa75a4c51a358d6a89302ac44d7d65dba38b6eb3760e7c399e8a3"
    sha256 cellar: :any,                 ventura:       "c8f7beb8652aa75a4c51a358d6a89302ac44d7d65dba38b6eb3760e7c399e8a3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ebccef92b3636d56d069bf11e441f68a3d344cd9b9bdbdc0ceb1f240afe5ac87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "54c797acfaaa25f1294234a65ee8e14cb5d07793f356fa6940073996b8805bca"
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