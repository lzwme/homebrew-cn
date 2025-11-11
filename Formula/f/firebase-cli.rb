class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-14.24.2.tgz"
  sha256 "8d27820484c80ac412ac203fb4f265f7d0c09d41d840ad531aa3a9abd2fb2ec1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "137b450710779179777c305b8fa28572bd08a0df0be672a2f53392f2b6ab6771"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "137b450710779179777c305b8fa28572bd08a0df0be672a2f53392f2b6ab6771"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "137b450710779179777c305b8fa28572bd08a0df0be672a2f53392f2b6ab6771"
    sha256 cellar: :any_skip_relocation, sonoma:        "52bcdb2185fbe632fea36480b47187579348ff1bb1d5a2c672043abdf2ea94a2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "24d5645f0cba324405b79ec745aa53c5448c91da1e26b151cb5b894f27cb3c14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "443c25d0814095a04f7c07201e2c70986ab0bc1fb91ac9173836027f6f1650af"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/firebase --version")

    assert_match "Failed to authenticate", shell_output("#{bin}/firebase projects:list", 1)
  end
end