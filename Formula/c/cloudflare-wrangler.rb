class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https:github.comcloudflareworkers-sdk"
  url "https:registry.npmjs.orgwrangler-wrangler-4.21.0.tgz"
  sha256 "c308cae79ac7bfe7c830a5132f6640d6e01fb218ca9e323cbc0fe65a1235ed32"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "bb0792ae836f2171f6a11522c559be62b0f9f76c2156555ebb5476fede7006c0"
    sha256 cellar: :any,                 arm64_sonoma:  "bb0792ae836f2171f6a11522c559be62b0f9f76c2156555ebb5476fede7006c0"
    sha256 cellar: :any,                 arm64_ventura: "bb0792ae836f2171f6a11522c559be62b0f9f76c2156555ebb5476fede7006c0"
    sha256                               sonoma:        "be44f6c434eca7400ae69454f5a0e98773f9f8198c6122a63881126c1d2c031f"
    sha256                               ventura:       "be44f6c434eca7400ae69454f5a0e98773f9f8198c6122a63881126c1d2c031f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "01d4f8d7c18b59efe111ff86c2b414dfac5beff0e251c133578a4129f2557e23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bbda844577b50163dd768d54520afef178728bcf31ac07bf271b72810df68b5c"
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