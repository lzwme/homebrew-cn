class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.94.0.tgz"
  sha256 "4a21f27550a9d7130808cf2ca09c7ec4e0695949d45b9d020a641d6a8475ef86"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ff300da061a778213315c2cf92d9c0fb90e2d93b12c8909784b3c3ace89a6dec"
    sha256 cellar: :any,                 arm64_sequoia: "a66bca695045ed98b5b606cc37ef855ae8d0cb76f720a5d9d4ffb87b9d5b36a4"
    sha256 cellar: :any,                 arm64_sonoma:  "a66bca695045ed98b5b606cc37ef855ae8d0cb76f720a5d9d4ffb87b9d5b36a4"
    sha256 cellar: :any,                 sonoma:        "9f6352b73b60e134b8074eb45e19e4de4ccd20391cf0d9a7403cadb4df6f7a3e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dab8ba5b5a8dde4e41dd8e12825dc99119cb5e9cff5e19b29ee3fd426ef857c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2a1d15e14c97c2c497dd39b974e5c3a522396457b8425bb7b666f6e91889dfac"
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