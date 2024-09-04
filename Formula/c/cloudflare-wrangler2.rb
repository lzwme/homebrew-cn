class CloudflareWrangler2 < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https:github.comcloudflareworkers-sdk"
  url "https:registry.npmjs.orgwrangler-wrangler-3.74.0.tgz"
  sha256 "d7e499db8930fbe6d9fa63f3d8f7b5aca926b58beccd9cb1c1b2fcc61cd2df96"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1383a0e1ffeb038e8a949a754c447dcc2adb351de4e4b722801c5e785415cc60"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1383a0e1ffeb038e8a949a754c447dcc2adb351de4e4b722801c5e785415cc60"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1383a0e1ffeb038e8a949a754c447dcc2adb351de4e4b722801c5e785415cc60"
    sha256 cellar: :any_skip_relocation, sonoma:         "5b14d1f5ee2645623a43e920c2dce927c990f2285cbb605201e2066f85f7c9c6"
    sha256 cellar: :any_skip_relocation, ventura:        "5b14d1f5ee2645623a43e920c2dce927c990f2285cbb605201e2066f85f7c9c6"
    sha256 cellar: :any_skip_relocation, monterey:       "5b14d1f5ee2645623a43e920c2dce927c990f2285cbb605201e2066f85f7c9c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9d78092feed313e7b887b908f668073e8f522a17303a7d0aa942db376065c566"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}binwrangler*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}wrangler -v")
    assert_match "Required Worker name missing", shell_output("#{bin}wrangler secret list 2>&1", 1)
  end
end