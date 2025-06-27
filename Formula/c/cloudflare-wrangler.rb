class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https:github.comcloudflareworkers-sdk"
  url "https:registry.npmjs.orgwrangler-wrangler-4.22.0.tgz"
  sha256 "a4a8e78b2df1ad4370182931c542dc833849355c29c8fafd795379aab356b8f2"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6bf8f1ed702b0a2a575952a82caa616b993f5f96ae6bd7d4be5a2294343df35c"
    sha256 cellar: :any,                 arm64_sonoma:  "6bf8f1ed702b0a2a575952a82caa616b993f5f96ae6bd7d4be5a2294343df35c"
    sha256 cellar: :any,                 arm64_ventura: "6bf8f1ed702b0a2a575952a82caa616b993f5f96ae6bd7d4be5a2294343df35c"
    sha256                               sonoma:        "32bc158464d612267d7f19b7db211b7a8f0c10b720c4a32605e8487ecce83871"
    sha256                               ventura:       "32bc158464d612267d7f19b7db211b7a8f0c10b720c4a32605e8487ecce83871"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5bd1e7913f691894363a79de64b72ad8dd48db0ed4ce5c8d23141678ec7edceb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "499b7ef19f2fccc82637aef073f8833d1b3400f760efe81d467a622d87c3cdaa"
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