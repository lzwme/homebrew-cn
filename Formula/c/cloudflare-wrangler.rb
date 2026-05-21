class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.93.0.tgz"
  sha256 "2bbf1185f87667e6b6a286c404d0b1351bd665f758ebf6ee72d79847d58350f6"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6406fd526849d717aa456699023b836c65d161280eed2608b566e42c1c37114f"
    sha256 cellar: :any,                 arm64_sequoia: "2c652ac61deeda090d7c5e14238da873f481db4980402f1a5d36491dc6847e9d"
    sha256 cellar: :any,                 arm64_sonoma:  "2c652ac61deeda090d7c5e14238da873f481db4980402f1a5d36491dc6847e9d"
    sha256 cellar: :any,                 sonoma:        "ad47f36ab7b4d32d7a46fa238d860f772dea7347d39f571152850b1eb99fffa9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0b1172165e91d3d5462094a0a2de80f709c6e795679c6a3988d500bc5613c0be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e63d55c8622c1203c928d5231c792ba276d08ab0962464b3df1de242d38b2425"
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