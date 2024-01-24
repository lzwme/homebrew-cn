require "languagenode"

class CloudflareWrangler2 < Formula
  include Language::Node::Shebang

  desc "CLI tool for Cloudflare Workers"
  homepage "https:github.comcloudflareworkers-sdk"
  url "https:registry.npmjs.orgwrangler-wrangler-3.24.0.tgz"
  sha256 "5d0ddb318515523c413df59e11a56abc2add4a72701fd03fad99fa80a59d3b3e"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4705acbeefe5765c153779878e81b7e55afc28a6531312339d4dc45f923532a8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4705acbeefe5765c153779878e81b7e55afc28a6531312339d4dc45f923532a8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4705acbeefe5765c153779878e81b7e55afc28a6531312339d4dc45f923532a8"
    sha256 cellar: :any_skip_relocation, sonoma:         "97446aa64676473c1a921f073d1aa432eb63bf4251070ca59e55f2b3fb15e92c"
    sha256 cellar: :any_skip_relocation, ventura:        "97446aa64676473c1a921f073d1aa432eb63bf4251070ca59e55f2b3fb15e92c"
    sha256 cellar: :any_skip_relocation, monterey:       "97446aa64676473c1a921f073d1aa432eb63bf4251070ca59e55f2b3fb15e92c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "77d021bec0c396f89d73170aca97ebce0617cc6e3a57289a908a0b24c494d650"
  end

  depends_on "node"

  conflicts_with "cloudflare-wrangler", because: "both install `wrangler` binaries"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    rewrite_shebang detected_node_shebang, *Dir["#{libexec}libnode_modules***"]
    bin.install_symlink Dir["#{libexec}binwrangler*"]

    # Replace universal binaries with their native slices
    deuniversalize_machos libexec"libnode_moduleswranglernode_modulesfseventsfsevents.node"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}wrangler -v")
    assert_match "Required Worker name missing", shell_output("#{bin}wrangler secret list 2>&1", 1)
  end
end