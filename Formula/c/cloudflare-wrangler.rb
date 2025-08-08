class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.28.1.tgz"
  sha256 "42d1402883ef23e664a2c346d6bfc8352fc6998d9b2d07c1c1e9899228a76def"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9762040ea6ff97c6a52eebd3939ae86cf5317a9bb5ce6c4bcb892b70f9ee24dd"
    sha256 cellar: :any,                 arm64_sonoma:  "9762040ea6ff97c6a52eebd3939ae86cf5317a9bb5ce6c4bcb892b70f9ee24dd"
    sha256 cellar: :any,                 arm64_ventura: "9762040ea6ff97c6a52eebd3939ae86cf5317a9bb5ce6c4bcb892b70f9ee24dd"
    sha256                               sonoma:        "a7895fe302b5d82037e45aeed04c7958b284eebd4bd3fa360219e9542a31ef54"
    sha256                               ventura:       "a7895fe302b5d82037e45aeed04c7958b284eebd4bd3fa360219e9542a31ef54"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8a1fe9e26b792f22fd3175a0c578fbc713cb10629ebf5d5bcfbdb56081f265c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fb5c3cc22d97f4c7fb90e2e7ce2eb8af3f8eb72757008de6cd397d6257af7c3c"
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