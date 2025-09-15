class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.37.0.tgz"
  sha256 "dfec43175087f45eba555bf3fae3515fb020c4601541815ebf2c1fc5253592a5"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "86a4ce370ae8593885733c6ec691dbbb79a8f73ab5c236434a59c1c82071ed0e"
    sha256 cellar: :any,                 arm64_sequoia: "1126ef152e9d49bbc57d490eaec98232a97ca49b340f0ffd3404c1f20006f411"
    sha256 cellar: :any,                 arm64_sonoma:  "1126ef152e9d49bbc57d490eaec98232a97ca49b340f0ffd3404c1f20006f411"
    sha256 cellar: :any,                 sonoma:        "55456fb05cb86f2cb9f3ee405b53aa01594f1e95658ce68e71185c593a7123a4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8202165785b347428b623afb4633ea9abb678e4a1d9a94f521a5efab06c455fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "137fb5aa2c9144b56329dbf3e358f65ec5483ce5d8fc1dc06edfad26fa28c853"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/wrangler*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wrangler -v")
    assert_match "Required Worker name missing", shell_output("#{bin}/wrangler secret list 2>&1", 1)
  end
end