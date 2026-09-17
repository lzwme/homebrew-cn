class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://developers.cloudflare.com/workers/"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.132.0.tgz"
  sha256 "63a61115b91a7698eaeafb66c4bc58913a155e5bc4534d75ae0683a4f3cddeb9"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "48fb11b600eb69220bb6786fa03c54721939a739a1619ff87f949f2aee62a8d1"
    sha256 cellar: :any, arm64_tahoe:       "48fb11b600eb69220bb6786fa03c54721939a739a1619ff87f949f2aee62a8d1"
    sha256 cellar: :any, arm64_sequoia:     "48fb11b600eb69220bb6786fa03c54721939a739a1619ff87f949f2aee62a8d1"
    sha256 cellar: :any, arm64_linux:       "4c40d8fdbbe06a5c24dca62fab5a70b045c4e76dd8d1a06b7e054c050828b80b"
    sha256 cellar: :any, x86_64_linux:      "7f8b05e9ca9681d49156ab7424bbae1dd0b43f67440e58bba8fe430a8416b3f8"
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