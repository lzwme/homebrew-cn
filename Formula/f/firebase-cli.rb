class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-14.25.0.tgz"
  sha256 "f98ed427faedb424b34dd21a9288cbc0571a28f25ef3bf1990ad079141d18c9a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5a5330e34b9eafdd6d271b0bd52b325f6ebf8dda9bc3588699e5c1211698047f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5a5330e34b9eafdd6d271b0bd52b325f6ebf8dda9bc3588699e5c1211698047f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5a5330e34b9eafdd6d271b0bd52b325f6ebf8dda9bc3588699e5c1211698047f"
    sha256 cellar: :any_skip_relocation, sonoma:        "32fd7f30255319f0761787ad7fbb22f877ee62c3caca1fad10674d829cd5ea66"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0e313956d96614390cad961694a3921d99d414245db318b5c51c1171b07545d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cce6214b474d595c7267ec02e0d526286318c5757158a29541cc8977da7f7144"
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