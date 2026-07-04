class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://developers.cloudflare.com/workers/"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.107.0.tgz"
  sha256 "58e5ede60dfd5efc5345daeb7bd93e7b9e0d5475c7ae4c651aa72b9c0f62dc43"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "a743224004b3ccc7caf9438c0cac95948fb29d9baf3953d3b2d3839ef7726bca"
    sha256 cellar: :any, arm64_sequoia: "55c116f75cfd5317edba415b76fc8a7564d7f751bb480e7d3962299623a1934a"
    sha256 cellar: :any, arm64_sonoma:  "55c116f75cfd5317edba415b76fc8a7564d7f751bb480e7d3962299623a1934a"
    sha256 cellar: :any, sonoma:        "0d29d47619c7d05ae233e9b525f20abebea2ee674b3df03a8fb1c549604c41ca"
    sha256 cellar: :any, arm64_linux:   "a303b3123884373a598813f85902a4dd54ba256b76c00db72be702a4a30d98a7"
    sha256 cellar: :any, x86_64_linux:  "9bf000c7d3ad6eefd8cf2881412efbab04b3f39ffc43136c41f27c4018495c66"
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