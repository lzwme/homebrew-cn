class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.86.0.tgz"
  sha256 "8c528c821ad0f9bf0b73b04b3b719e2baa654886b25b1425cff2507bccabec6b"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4ceda2f0719c268ed1ec845fdbfb9344c9dcf65dba01dbc55aab8588462aef8e"
    sha256 cellar: :any,                 arm64_sequoia: "bfc830b19276f74c49131539ef6e7333ca6a99c4ef5b1cd0c6e144e34b111a23"
    sha256 cellar: :any,                 arm64_sonoma:  "bfc830b19276f74c49131539ef6e7333ca6a99c4ef5b1cd0c6e144e34b111a23"
    sha256 cellar: :any,                 sonoma:        "ed826725f0c0693601b8e63b17f8a3589e198e8ce4c5b514110cbfb6a0b3d608"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4a7e658294103231b1abea59f7289cef6710b1f416e45f93c5ab028c34d067c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "42bea1b102167b1de064a0e2531a534a0ca1412726fbd65b03de0c679cb24383"
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