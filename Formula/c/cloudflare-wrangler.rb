class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://developers.cloudflare.com/workers/"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.110.0.tgz"
  sha256 "470909753336d871b25f14b17c1e312d0b4112cbedd295b2ab1b341f71f71106"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "c86758e7d67b3375784e7aeb2c6c2ae0e43b5b860a05624bb9b0fb94a9e51eca"
    sha256 cellar: :any, arm64_sequoia: "1849625c7e781069477e8a180c403a10dedc539eccfc27a9db4b414fbd528e10"
    sha256 cellar: :any, arm64_sonoma:  "1849625c7e781069477e8a180c403a10dedc539eccfc27a9db4b414fbd528e10"
    sha256 cellar: :any, sonoma:        "c32ae17204b93acce5147750af4c9d5699968d09389a72a1e424388fbea00298"
    sha256 cellar: :any, arm64_linux:   "e3875d52fe13b66b56c19638744b381b5801228a2675acafe6f01e5571e43222"
    sha256 cellar: :any, x86_64_linux:  "4b016b445ef8119f871be1529a116bb50b9a59a9ffab550ee73d051246715963"
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