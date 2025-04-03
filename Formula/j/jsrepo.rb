class Jsrepo < Formula
  desc "Build and distribute your code"
  homepage "https://jsrepo.dev/"
  url "https://registry.npmjs.org/jsrepo/-/jsrepo-1.45.3.tgz"
  sha256 "73c40bb50726d2d2f1767bd02a3bfeb694fe62c386361799a3db107251b489ee"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6a6ecb482380eb8fd5e00188b91c8ef994000190a0789d10e9e6c9725ee5fb1a"
    sha256 cellar: :any,                 arm64_sonoma:  "6a6ecb482380eb8fd5e00188b91c8ef994000190a0789d10e9e6c9725ee5fb1a"
    sha256 cellar: :any,                 arm64_ventura: "6a6ecb482380eb8fd5e00188b91c8ef994000190a0789d10e9e6c9725ee5fb1a"
    sha256 cellar: :any,                 sonoma:        "bfb5b56acf49ba51a68b7433b0bfc741609d8ee8f8b438c01aced4f7e62e493d"
    sha256 cellar: :any,                 ventura:       "bfb5b56acf49ba51a68b7433b0bfc741609d8ee8f8b438c01aced4f7e62e493d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dfab95b71f3fb620fdd7ebc2c5571046887867a9714e801c774d074a12ff8f4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "43c1f5eb63ede57f96cad8e5ea411f1487d4252ab6b095ff4f82a4482ecec52e"
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