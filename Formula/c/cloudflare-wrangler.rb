class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://developers.cloudflare.com/workers/"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.111.0.tgz"
  sha256 "efbd0e6780732eb8ee1350f7f18c781f6d6e183686a55496ae4c77b06fef9053"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "8f416c8c0f58ae017677cf82c870cc0cee8e2561638f672996d2858dd97b23b2"
    sha256 cellar: :any, arm64_sequoia: "8f416c8c0f58ae017677cf82c870cc0cee8e2561638f672996d2858dd97b23b2"
    sha256 cellar: :any, arm64_sonoma:  "8f416c8c0f58ae017677cf82c870cc0cee8e2561638f672996d2858dd97b23b2"
    sha256 cellar: :any, sonoma:        "9f390b91b6244a0b165883a315e13bb258b3c04628403db7dd157835058fc550"
    sha256 cellar: :any, arm64_linux:   "39d312a71526b08f27d1154da4846d9246f9ea45586e82dc326b0399828f86f1"
    sha256 cellar: :any, x86_64_linux:  "971c9638ed4a5478d8e8fce89afae109aedc5493b019495ec04259fd01b250e2"
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