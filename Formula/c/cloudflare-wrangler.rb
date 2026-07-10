class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://developers.cloudflare.com/workers/"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.108.0.tgz"
  sha256 "96abe95caba09694983764ff1a89566a961994c9c94e577a0ef3a45d880dc4a2"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "47bb8c23427362b751132eb1e9675101882ee880c49e6c27a839e1cb2df84d46"
    sha256 cellar: :any, arm64_sequoia: "f6e2beb764a2e21eca9a40ca7925cc837b59b828e8453f71fb75b1a94826dbc7"
    sha256 cellar: :any, arm64_sonoma:  "f6e2beb764a2e21eca9a40ca7925cc837b59b828e8453f71fb75b1a94826dbc7"
    sha256 cellar: :any, sonoma:        "0027668136d8d8fe9a1cc9ab8c1023637e2d244da881152bac6793192d3682df"
    sha256 cellar: :any, arm64_linux:   "cf4fbcf8cc67642475d019b9d81a155b7d6c85d7897d72dc69767fe7438b6554"
    sha256 cellar: :any, x86_64_linux:  "39df02daf3513301ebc87763f6034ae022322e8c0471eac31bfdcd002cbcfa17"
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