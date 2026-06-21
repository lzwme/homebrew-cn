class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://developers.cloudflare.com/workers/"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.103.0.tgz"
  sha256 "37c776f63e5fab6bc7904f840a7258fe22e9cbb20c0d9b8b6f70cd95d15dc6e0"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "2bbcb33783ee6e1e7520a2d425c344d702afd3743b85779707d7bacf067960c9"
    sha256 cellar: :any, arm64_sequoia: "8c1329afcbbb7ffa72ff68d786b31891b91b4890b3087ca234995e93fc3da6ed"
    sha256 cellar: :any, arm64_sonoma:  "8c1329afcbbb7ffa72ff68d786b31891b91b4890b3087ca234995e93fc3da6ed"
    sha256 cellar: :any, sonoma:        "7baec343374c5bf2c0416f60467cfa5170458bdd4157ef847b9ea13eebee5458"
    sha256 cellar: :any, arm64_linux:   "c7d74b292b7c8179d49e3f44952376cd0b7945cc4e12a5b6a0fd75cefdf5d458"
    sha256 cellar: :any, x86_64_linux:  "b0a26722827a5856cdba66450d413ab5035c711b152fd0a4265a41b54875c368"
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