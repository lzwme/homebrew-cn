class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.29.1.tgz"
  sha256 "c501deea00d9b791c6a32695d8e549dc88dae4fee5948130e23b634783afd469"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c8a6ac579f06bdb20c23b31e886d47191f7b21360a2c98cd1d8a2d216c37aba7"
    sha256 cellar: :any,                 arm64_sonoma:  "c8a6ac579f06bdb20c23b31e886d47191f7b21360a2c98cd1d8a2d216c37aba7"
    sha256 cellar: :any,                 arm64_ventura: "c8a6ac579f06bdb20c23b31e886d47191f7b21360a2c98cd1d8a2d216c37aba7"
    sha256                               sonoma:        "8d836780584470ff1b87293617d4af7b164ae09d713bb30aba9c857f6dd2d4ae"
    sha256                               ventura:       "8d836780584470ff1b87293617d4af7b164ae09d713bb30aba9c857f6dd2d4ae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "65f6a66dd86248f632ad8dca7b2fceb569cfbcd7c5ef1895ed1dfcc0c9aeec51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "42f07cbe9338d6374ab1167010b9c97870a0d7a7e3d2cc7bfef017293b58fa7f"
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