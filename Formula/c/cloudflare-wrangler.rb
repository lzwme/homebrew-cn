class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https:github.comcloudflareworkers-sdk"
  url "https:registry.npmjs.orgwrangler-wrangler-4.19.2.tgz"
  sha256 "5a7ab582d518c736873cedc29332113eb83ad1dbb73d3da4f6c5fe83dc02e083"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "96ac10e36ef8c3799d3f5bd0baccdc2816c02f5afb199a07b81ba6bee2d6df22"
    sha256 cellar: :any,                 arm64_sonoma:  "96ac10e36ef8c3799d3f5bd0baccdc2816c02f5afb199a07b81ba6bee2d6df22"
    sha256 cellar: :any,                 arm64_ventura: "96ac10e36ef8c3799d3f5bd0baccdc2816c02f5afb199a07b81ba6bee2d6df22"
    sha256                               sonoma:        "1ea8e811cb3ba3d82dc15401726cd147838ef5c8fae3d7c3343336e7180eab8b"
    sha256                               ventura:       "1ea8e811cb3ba3d82dc15401726cd147838ef5c8fae3d7c3343336e7180eab8b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "38c7132eca457e48fdf31cf72354b7c63980b9e43f0c8ea0902b44643787da47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a2de2508de5ed66d1902a399faaecc262166e1e7489874c40207421959bf5c5"
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