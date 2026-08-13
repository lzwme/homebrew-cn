class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://developers.cloudflare.com/workers/"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.121.0.tgz"
  sha256 "3d3a64b5cb7779fcc7bb1e05e3e15286b6f31289fb74b09c08ef3c0c3f3eedf7"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "055b74a960f873ae95c9b715ad153cec8a506bf47402537700eedbf5a1711cc3"
    sha256 cellar: :any, arm64_sequoia: "055b74a960f873ae95c9b715ad153cec8a506bf47402537700eedbf5a1711cc3"
    sha256 cellar: :any, arm64_sonoma:  "055b74a960f873ae95c9b715ad153cec8a506bf47402537700eedbf5a1711cc3"
    sha256 cellar: :any, sonoma:        "82652c26ae115a6f31f8dfb2b0f36d5186e7e6106d6c48ae5c1cf9ba524cc34a"
    sha256 cellar: :any, arm64_linux:   "265e9f4022833409ef1f103e838d5acc6af58f4ca6d19fbfd70c73bd663cb726"
    sha256 cellar: :any, x86_64_linux:  "4cb46120e65c4000c1c787533af6edf0a56cc0e0968833e0ccba35267a653d71"
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