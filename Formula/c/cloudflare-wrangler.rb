class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://developers.cloudflare.com/workers/"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.122.0.tgz"
  sha256 "2110b6425a690ce3cd7e5a6ee08c3be98d89b234951f7814ed4965c3b5886ae4"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "ff12cc2bcfbeb1f0cc3da3e7d86dea206df6844570156fb7a7b7ea94d6a955f8"
    sha256 cellar: :any, arm64_sequoia: "ff12cc2bcfbeb1f0cc3da3e7d86dea206df6844570156fb7a7b7ea94d6a955f8"
    sha256 cellar: :any, arm64_sonoma:  "ff12cc2bcfbeb1f0cc3da3e7d86dea206df6844570156fb7a7b7ea94d6a955f8"
    sha256 cellar: :any, sonoma:        "3ec9066b45e428ba84b2bf2101b6cf69ef137c14685fb3132ca3b2f33f054bb0"
    sha256 cellar: :any, arm64_linux:   "e1905c83081c2d5a5d8b37df0b4385dec0423272923dfc165faa6015157efc2d"
    sha256 cellar: :any, x86_64_linux:  "105d624682a42a63691ec871226c60937ab554aafe3c0356a9c7be54986164ed"
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