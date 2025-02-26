class Jsrepo < Formula
  desc "Build and distribute your code"
  homepage "https://jsrepo.dev/"
  url "https://registry.npmjs.org/jsrepo/-/jsrepo-1.41.0.tgz"
  sha256 "252ed286e3c02c347b908efbd0825c5ed26284168879eb309ab252a83f664b8a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "86f1f6950c51d6ee5fdff4df801593b71e4b3fe0e3d8ea700723162ae2dbce6a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "86f1f6950c51d6ee5fdff4df801593b71e4b3fe0e3d8ea700723162ae2dbce6a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "86f1f6950c51d6ee5fdff4df801593b71e4b3fe0e3d8ea700723162ae2dbce6a"
    sha256 cellar: :any_skip_relocation, sonoma:        "348430961f594b7f2894150f199d0a5e1e666d9605912642e0a873539e5b5122"
    sha256 cellar: :any_skip_relocation, ventura:       "348430961f594b7f2894150f199d0a5e1e666d9605912642e0a873539e5b5122"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "86f1f6950c51d6ee5fdff4df801593b71e4b3fe0e3d8ea700723162ae2dbce6a"
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