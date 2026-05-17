class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.92.0.tgz"
  sha256 "296aef1f7208c77691e0e970dd6f4940c599ed4c45b26432fb35fe2550182468"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "329dadcaa33602206cf08e7c39dd042505c9c15238d02717b1ee9ea51a40106c"
    sha256 cellar: :any,                 arm64_sequoia: "dbd9209a3f6a970a2c2ed4180209aecee3cbacd88dde4d383086832d58c7078f"
    sha256 cellar: :any,                 arm64_sonoma:  "dbd9209a3f6a970a2c2ed4180209aecee3cbacd88dde4d383086832d58c7078f"
    sha256 cellar: :any,                 sonoma:        "0089148140623e68dc2b363ddf05ed07c4236f459bc1d9ce0a9493102dbfb05f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "050281714145b2d9ce8a5963b67ec93339c5fb329b7585de5f10d525612a2c11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bc99b638470c9d3c631cf05fe31a406d7619a2e508ed1b45ba6e2d16c284083c"
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