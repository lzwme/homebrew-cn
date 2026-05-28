class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.95.0.tgz"
  sha256 "0822d9687f211fe0196e500c6c9f60a4f5d238ee7461e01ee98d8ef8f80c47bd"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "67d8c157a2ee59a51ba61c62192425fbdba054103b2c9ebb281ec8ce94135764"
    sha256 cellar: :any,                 arm64_sequoia: "1b48294c2ce8b31896cdbe545ed868f8f2803b8cdd217250ee91418115206834"
    sha256 cellar: :any,                 arm64_sonoma:  "1b48294c2ce8b31896cdbe545ed868f8f2803b8cdd217250ee91418115206834"
    sha256 cellar: :any,                 sonoma:        "ca8511a95ece6d16e630c09d4558ee0d2edc386cf102e52407586c738788b354"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9be74d34a43a746d15db8f29a960c5676b91d71975f904003a802736f69eda5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c29ca548a8752f4b30a92a7409381e52b9b33ece6480917cb712825a791465d8"
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