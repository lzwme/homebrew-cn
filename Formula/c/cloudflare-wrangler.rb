class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://developers.cloudflare.com/workers/"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.134.0.tgz"
  sha256 "0161f9532b530609de5bcb84643ac6e25afcf76496e53c3049afbe1bedf10acc"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "6696a69c451502f265ed352cb246fd7f42c801831c403c97418adc5f539595f3"
    sha256 cellar: :any, arm64_tahoe:       "6696a69c451502f265ed352cb246fd7f42c801831c403c97418adc5f539595f3"
    sha256 cellar: :any, arm64_sequoia:     "6696a69c451502f265ed352cb246fd7f42c801831c403c97418adc5f539595f3"
    sha256 cellar: :any, arm64_linux:       "468d00ffc58be4488e0095b28fdb590a3a566c5303842a68d0e2891fa2556ba7"
    sha256 cellar: :any, x86_64_linux:      "3fbc36644715eb9f38de57b8eea0b7784b181bb3c142cbed71cb8365d97f19f8"
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