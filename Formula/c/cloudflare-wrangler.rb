class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https:github.comcloudflareworkers-sdk"
  url "https:registry.npmjs.orgwrangler-wrangler-4.7.0.tgz"
  sha256 "fe2b0e9b870796cd60815e9c94281dc789882646cbc766ab6a892d081f899cf8"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a1ed0cdbfb64e9562cf13cbe1fa3e8001a3d77cb7e4bd82a96c6c40e79e71255"
    sha256 cellar: :any,                 arm64_sonoma:  "a1ed0cdbfb64e9562cf13cbe1fa3e8001a3d77cb7e4bd82a96c6c40e79e71255"
    sha256 cellar: :any,                 arm64_ventura: "a1ed0cdbfb64e9562cf13cbe1fa3e8001a3d77cb7e4bd82a96c6c40e79e71255"
    sha256                               sonoma:        "33597ff6b916c92d78f6688b3bbc8d7d21562ec017c39bb21b532fbfd062345f"
    sha256                               ventura:       "33597ff6b916c92d78f6688b3bbc8d7d21562ec017c39bb21b532fbfd062345f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3e8c5629cd3fe3ab91c90c0db8d614aee53b1277136f376bbffc1fd745657012"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b9fe89fb8166f821a59d47a473c5b9b01f75f3a9a11a8d3dff1691db2236d5e0"
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