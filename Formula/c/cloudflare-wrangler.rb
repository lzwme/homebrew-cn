class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https:github.comcloudflareworkers-sdk"
  url "https:registry.npmjs.orgwrangler-wrangler-4.20.3.tgz"
  sha256 "3e66ac43892cb09d15db382a03a176f1e77429d9ab33fee9b9df3bbf1af6445b"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "949ec537bf3a98f94bd91c7c45f1fa3ecdb0758a292da7f96bc631f6405182ce"
    sha256 cellar: :any,                 arm64_sonoma:  "949ec537bf3a98f94bd91c7c45f1fa3ecdb0758a292da7f96bc631f6405182ce"
    sha256 cellar: :any,                 arm64_ventura: "949ec537bf3a98f94bd91c7c45f1fa3ecdb0758a292da7f96bc631f6405182ce"
    sha256                               sonoma:        "a706c9836ed9e6988ad12d01d6ce4df0e30acd592d32274ac10b3a32ce40a251"
    sha256                               ventura:       "a706c9836ed9e6988ad12d01d6ce4df0e30acd592d32274ac10b3a32ce40a251"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "71e0cba0cc9b1d4eca2785c0f6aedc0f6d60a60e46f9635dcac517ee146e3a71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "71f2b69363e2c154aa3eac08f25ecde9cbb7c6259d967ccb3db886e2f0a13b92"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}binwrangler*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}wrangler -v")
    assert_match "Required Worker name missing", shell_output("#{bin}wrangler secret list 2>&1", 1)
  end
end