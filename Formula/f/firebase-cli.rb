class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-14.21.0.tgz"
  sha256 "a257bf3d164a1cac29106d51199a352c0d62a03cab5d2bf3db457034b17bdba4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8e0f260246ba649f909197c622ff8df5d6ffd72295821473d34251127410d0d4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8e0f260246ba649f909197c622ff8df5d6ffd72295821473d34251127410d0d4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8e0f260246ba649f909197c622ff8df5d6ffd72295821473d34251127410d0d4"
    sha256 cellar: :any_skip_relocation, sonoma:        "3f763756455db6b67d0a2b992596b0c339bf6582d68f1ef3a3987de8e15e437c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b2db954528c460b7568344741a12c2e7f9b16b8efbc7fb6913f3410691e15b4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "394af6405834807d571fab6626cdf1a1e74c8a57d928fe1f5e5ac1547561a2c2"
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