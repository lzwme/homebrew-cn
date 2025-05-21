class Jsrepo < Formula
  desc "Build and distribute your code"
  homepage "https://jsrepo.dev/"
  url "https://registry.npmjs.org/jsrepo/-/jsrepo-2.0.4.tgz"
  sha256 "e36d6344b96a23897eb57e4a05e17316406f9bc7de3a567278b1df7cbfc65e0f"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "47de02d1b607045f8cb978e96c1c56a368e2c32bc1c9a129d8cb016c42dcf7e9"
    sha256 cellar: :any,                 arm64_sonoma:  "47de02d1b607045f8cb978e96c1c56a368e2c32bc1c9a129d8cb016c42dcf7e9"
    sha256 cellar: :any,                 arm64_ventura: "47de02d1b607045f8cb978e96c1c56a368e2c32bc1c9a129d8cb016c42dcf7e9"
    sha256 cellar: :any,                 sonoma:        "75d6a6601ce31a13198ce4a323c1b9aa8b90bc84c7ba678892ef779bfb8829b3"
    sha256 cellar: :any,                 ventura:       "75d6a6601ce31a13198ce4a323c1b9aa8b90bc84c7ba678892ef779bfb8829b3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "40a0d64a53c5cf2d4e02c47eea9cd9e91b72e9ff74874a8bf4f2bba98a25c4a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "464f9984727497806a500c90b0beeb3b59c2562058ea150ab7394d39b1d663f5"
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