class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://developers.cloudflare.com/workers/"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.141.0.tgz"
  sha256 "e1fdebec678edecac7eb0703a65d8192e5e00fe53d639f98c9889976f394d208"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "be8ec7506472cbfc7e1f8dadf8d77e79d7bb82dc9cf4762998855bf244141137"
    sha256 cellar: :any, arm64_tahoe:       "be8ec7506472cbfc7e1f8dadf8d77e79d7bb82dc9cf4762998855bf244141137"
    sha256 cellar: :any, arm64_sequoia:     "be8ec7506472cbfc7e1f8dadf8d77e79d7bb82dc9cf4762998855bf244141137"
    sha256 cellar: :any, arm64_linux:       "c9a5e90ffeaa767fd13891ecd4f02f241c7b07dae06aa0bada36ab2f4c563e1c"
    sha256 cellar: :any, x86_64_linux:      "3903c8b4584cf7e023c9e71b589bbc5e49c8c21f5ef7c1f75f2ebb166cc782a8"
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