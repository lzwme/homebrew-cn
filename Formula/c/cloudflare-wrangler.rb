class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://developers.cloudflare.com/workers/"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.148.0.tgz"
  sha256 "8b24da29fead6536d643b0cb25220d727c2492a9050f61838116371da7449f3a"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "5a89e8bd0b7e6e1d96347efc6703ed85f26fa9bcc1716b30a9b6378eade9db00"
    sha256 cellar: :any, arm64_tahoe:       "5a89e8bd0b7e6e1d96347efc6703ed85f26fa9bcc1716b30a9b6378eade9db00"
    sha256 cellar: :any, arm64_sequoia:     "5a89e8bd0b7e6e1d96347efc6703ed85f26fa9bcc1716b30a9b6378eade9db00"
    sha256 cellar: :any, arm64_linux:       "becd780a2174404b99f8a0db8d9c1652a0f4b2bf59dbd3457dece7282bfd20fa"
    sha256 cellar: :any, x86_64_linux:      "1f01d7a99c778ac645e821f509fa682571294e4f214fa04121e47ca5820d783c"
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