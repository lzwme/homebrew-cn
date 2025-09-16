class Jsrepo < Formula
  desc "Build and distribute your code"
  homepage "https://jsrepo.dev/"
  url "https://registry.npmjs.org/jsrepo/-/jsrepo-2.4.8.tgz"
  sha256 "f11302de7e886ca442f2db6aaae76d95809ac226b2e7740de522a8400e18106b"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5feb41abf18f6a289d6f76404ab56725dc390ced27b1bd278bf4a39cb2345ae6"
    sha256 cellar: :any,                 arm64_sequoia: "2950d0d44db903c6442000e86c0d387d5220a4903401419c8f758f5d69af49d8"
    sha256 cellar: :any,                 arm64_sonoma:  "2950d0d44db903c6442000e86c0d387d5220a4903401419c8f758f5d69af49d8"
    sha256 cellar: :any,                 sonoma:        "68c8c2825949042bfde261563ac2b480c2a29f5fa5aef2fa584be497693b89ae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2091640c1e74d7401f7a32d1594360d97e04192ffc09005b6164666bce552b9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "299aea3199a00bc33e3dc6d87a013cbd6917e30fd47a9f365b9fe4d24f1750e8"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jsrepo --version")

    system bin/"jsrepo", "build"
    assert_match "\"categories\": []", (testpath/"jsrepo-manifest.json").read
  end
end