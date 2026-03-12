class Lerna < Formula
  desc "Tool for managing JavaScript projects with multiple packages"
  homepage "https://lerna.js.org"
  url "https://registry.npmjs.org/lerna/-/lerna-9.0.6.tgz"
  sha256 "297a91f60688a62b1eb364b8ce92bc1f637203dc76e966e3f2783239b52914dc"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "55a1ab3e05f143e27c721a3f90e6508b0c750aa9133146050c16af186e9607b5"
    sha256 cellar: :any,                 arm64_sequoia: "a38c9e6a5ebd14a90e4f49cdb31a33e4cb1a1b5e462428c02ff7da301e83d0bb"
    sha256 cellar: :any,                 arm64_sonoma:  "a38c9e6a5ebd14a90e4f49cdb31a33e4cb1a1b5e462428c02ff7da301e83d0bb"
    sha256 cellar: :any,                 sonoma:        "cd2c9854f46abbd5e08ec709aae82873d1b831db3d8cfb8dda8ffd844ea62493"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b2dc98a7de97a6a74ecd5ccfb2fe2691ec9d0a7c9678ba544fdc6e752ccca34f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a031b00ebb92d2828950007a27b22d65b791477555950b5865d51d8f88619429"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lerna --version")

    output = shell_output("#{bin}/lerna init --independent 2>&1")
    assert_match "lerna success Initialized Lerna files", output
  end
end