class Jsrepo < Formula
  desc "Build and distribute your code"
  homepage "https://jsrepo.dev/"
  url "https://registry.npmjs.org/jsrepo/-/jsrepo-2.3.2.tgz"
  sha256 "b5a8b38474643e93a6a7387a973ed778afdaa49d7019c7693a99929f027beb2b"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "03d87eb980565203f5e2019afabd86eb575ba459215307ae386e672890686bb1"
    sha256 cellar: :any,                 arm64_sonoma:  "03d87eb980565203f5e2019afabd86eb575ba459215307ae386e672890686bb1"
    sha256 cellar: :any,                 arm64_ventura: "03d87eb980565203f5e2019afabd86eb575ba459215307ae386e672890686bb1"
    sha256 cellar: :any,                 sonoma:        "40c2425af0124b1d378dc0a68b7d818e91fb45aadab0b90dacb7b55a462a79bc"
    sha256 cellar: :any,                 ventura:       "40c2425af0124b1d378dc0a68b7d818e91fb45aadab0b90dacb7b55a462a79bc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "637a132ede9b4f63a24f35a8ce308118f8539b61c1960aba04c012056ed20c4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b7c49552685cbc054cd13ab556d333f9aeec3eead66e7a934694b3edb3c26d43"
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