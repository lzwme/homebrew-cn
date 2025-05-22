class Jsrepo < Formula
  desc "Build and distribute your code"
  homepage "https://jsrepo.dev/"
  url "https://registry.npmjs.org/jsrepo/-/jsrepo-2.1.0.tgz"
  sha256 "7775ebd799e51a219ae63c1e172bfd412286a0fa7fe0d07240657a786e405e8f"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "fb79328e151d766fe91af0320ec028b06e6ef06d4b3c1809a1ddce647bcad6a5"
    sha256 cellar: :any,                 arm64_sonoma:  "fb79328e151d766fe91af0320ec028b06e6ef06d4b3c1809a1ddce647bcad6a5"
    sha256 cellar: :any,                 arm64_ventura: "fb79328e151d766fe91af0320ec028b06e6ef06d4b3c1809a1ddce647bcad6a5"
    sha256 cellar: :any,                 sonoma:        "ce277b9bc3531c7d7f55f00fa6b9ee5eb7b03e28ff96be20dc279d58dfb86cb3"
    sha256 cellar: :any,                 ventura:       "ce277b9bc3531c7d7f55f00fa6b9ee5eb7b03e28ff96be20dc279d58dfb86cb3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "49aaf9c7187f70e62032cb496b9971781ac64435848a71f801bb6e13a7aeb00d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f6db90c2492cc5b4e71075673b585d68c886a6a5e21eb2f3981aa0c94d5455c7"
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