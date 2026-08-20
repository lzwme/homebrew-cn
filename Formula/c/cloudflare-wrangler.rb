class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://developers.cloudflare.com/workers/"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.124.0.tgz"
  sha256 "f728c4987ff101beedc38aa76dabca9467ea47ace3604b2ff2582b437f7dd415"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "5d006dd81df6dfa182cb3472ec63e17a0dd1db5a05562d9e75ea0ec4f224b5b2"
    sha256 cellar: :any, arm64_sequoia: "5d006dd81df6dfa182cb3472ec63e17a0dd1db5a05562d9e75ea0ec4f224b5b2"
    sha256 cellar: :any, arm64_sonoma:  "5d006dd81df6dfa182cb3472ec63e17a0dd1db5a05562d9e75ea0ec4f224b5b2"
    sha256 cellar: :any, sonoma:        "b7172be69afe54f59c598af8cba7787d23bdea10d7e8f259ce8e5eda49f1a147"
    sha256 cellar: :any, arm64_linux:   "c8e3335fa856e20dabe0885cbebb1eb8008f74653d19d129670b527b8a76d94f"
    sha256 cellar: :any, x86_64_linux:  "eb871000632ee3ed893ba5cfb8e084fe009dbcf78c2ce10515ce79d8204a8f75"
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