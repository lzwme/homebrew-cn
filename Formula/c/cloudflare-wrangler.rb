class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://developers.cloudflare.com/workers/"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.150.0.tgz"
  sha256 "4eb3280e791b3ff199208150e768c625aeb594634d6d20a1b388c4eef321a9ca"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "d585e96db65e9806e28d686c80562bd36bf5ec65387ce5669b56a10cb53965e3"
    sha256 cellar: :any, arm64_tahoe:       "d585e96db65e9806e28d686c80562bd36bf5ec65387ce5669b56a10cb53965e3"
    sha256 cellar: :any, arm64_sequoia:     "d585e96db65e9806e28d686c80562bd36bf5ec65387ce5669b56a10cb53965e3"
    sha256 cellar: :any, arm64_linux:       "4149a311c172939b3eaf814ba4a77c21128e9513105c506f7b935c1aa37dd0a8"
    sha256 cellar: :any, x86_64_linux:      "9d458be295b1dbee42d7e5f85bfa141db22efd78465ec08da64432e9078d4ae0"
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