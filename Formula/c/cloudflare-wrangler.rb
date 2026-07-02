class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://developers.cloudflare.com/workers/"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.106.0.tgz"
  sha256 "b56b4a59a84f2211bae902e63d57bb5634074a7a2a88b8e2926f95b2440dd214"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "aef27a93f86abe91366dc3a725760186ce9c7bb23bce88be191fa649955f00d7"
    sha256 cellar: :any, arm64_sequoia: "78e11277904030e5241815ffc1835ab6c22bab3af87c3ea3706c94a4dbddc950"
    sha256 cellar: :any, arm64_sonoma:  "78e11277904030e5241815ffc1835ab6c22bab3af87c3ea3706c94a4dbddc950"
    sha256 cellar: :any, sonoma:        "bcfca88d5b845fc2405b58fa2d5f3d585daf9cc1d77db227fe6dec6905f92576"
    sha256 cellar: :any, arm64_linux:   "85acbf85f43824fa7bc8c4929dbfb62ea902a866af0662829ca99e826dda5754"
    sha256 cellar: :any, x86_64_linux:  "e11ee43db046b3edaac8fce10a342be9dfc345dd7a94e59aae75355e19557cd1"
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