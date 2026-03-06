class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.71.0.tgz"
  sha256 "197961da316fd5c12fe5dfc68117f0587b8b80c07ccbcc1c12c9b7e8bcfdf482"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c3500db82ad8ce6d276d30e54a42bd05bcd9d9db7e8b84fb9ec2fb4bda9d5f62"
    sha256 cellar: :any,                 arm64_sequoia: "0f45fad29ef3b1c7f991ef0222b45bf51596ab7824b4a842196d7cb7fddfc4e2"
    sha256 cellar: :any,                 arm64_sonoma:  "0f45fad29ef3b1c7f991ef0222b45bf51596ab7824b4a842196d7cb7fddfc4e2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3414aa8c4df02979c601cfade19cf6f7b8a961738d75aa1f699f53b2f6bde171"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "061cdc97b4c5edab836a59023554b5a8382975abf7be2792f78032fd6f9205c0"
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