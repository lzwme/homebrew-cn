class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://developers.cloudflare.com/workers/"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.130.0.tgz"
  sha256 "244a51bb7d8f6b0586dddd61e2468825a599863ff667a66a2d92034a792c9b6c"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "5621c3d6f85025220984298da2124423673d78c7464d6fd92533f5b98ac942ce"
    sha256 cellar: :any, arm64_sequoia: "5621c3d6f85025220984298da2124423673d78c7464d6fd92533f5b98ac942ce"
    sha256 cellar: :any, arm64_sonoma:  "5621c3d6f85025220984298da2124423673d78c7464d6fd92533f5b98ac942ce"
    sha256 cellar: :any, arm64_linux:   "c0415a334c6095b11c56dbd7f6d2868e7aa3769505ea1e00bbb3ea8585f6b095"
    sha256 cellar: :any, x86_64_linux:  "6b97ea25bcb05fbd1b12a440cdd1dff2d8a39e968a9cd7fbbd7d2758844cf96f"
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