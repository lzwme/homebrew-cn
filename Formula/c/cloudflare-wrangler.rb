class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.93.1.tgz"
  sha256 "9048214d3af5176cd844d9bd7cfa1b86e974fe287c32f10f9f8f72c48a3d3444"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8546e16c06063834465095a8eded1e9982883e6ad57eec5f9010ac2db96b6ca6"
    sha256 cellar: :any,                 arm64_sequoia: "8dccb67e0222d19e8356dcdc7a02ea17a4343328ec29c5effee5bf08417ef04d"
    sha256 cellar: :any,                 arm64_sonoma:  "8dccb67e0222d19e8356dcdc7a02ea17a4343328ec29c5effee5bf08417ef04d"
    sha256 cellar: :any,                 sonoma:        "461a8647aebde5de27828487393df65c443e761927b4776a724631a1c89bbe04"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f57160f0a495297a71a3603a74f31bc02f2c4e25c807866977a3a2f7cd4f7b7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d710f31c8800f0e120bae30e061cfa950113b37bcc0f7fe193f47f8550558be2"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/wrangler*"]

    node_modules = libexec/"lib/node_modules/wrangler/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?

    generate_completions_from_executable(bin/"wrangler", "complete", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wrangler -v")
    assert_match "Required Worker name missing", shell_output("#{bin}/wrangler secret list 2>&1", 1)
  end
end