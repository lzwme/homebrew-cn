class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://developers.cloudflare.com/workers/"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.155.0.tgz"
  sha256 "b7735eef797a2d85a5802e845a561d951a249ba98a6638ad52f1079f821ccf75"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "c9b998bc6933d21115c7fc95c2dd291552eee03f6d5879c2aadb7972ab931d4e"
    sha256 cellar: :any, arm64_tahoe:       "c9b998bc6933d21115c7fc95c2dd291552eee03f6d5879c2aadb7972ab931d4e"
    sha256 cellar: :any, arm64_sequoia:     "c9b998bc6933d21115c7fc95c2dd291552eee03f6d5879c2aadb7972ab931d4e"
    sha256 cellar: :any, arm64_linux:       "845e06baf1eff58ede48427bafaf117d745baf8a06f548182c0bc95d27bb31d3"
    sha256 cellar: :any, x86_64_linux:      "647ecf6b02532fc5541c325184149e2e15cbfb6ea6ab5b343571241bde400319"
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