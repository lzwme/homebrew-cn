class Jsrepo < Formula
  desc "Build and distribute your code"
  homepage "https://jsrepo.dev/"
  url "https://registry.npmjs.org/jsrepo/-/jsrepo-2.0.3.tgz"
  sha256 "5a7f482c660838e6c9fffbd358afa6445cf84561621c6c975ab03936fe8fb3b3"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c4c0c0aef3b106ed7d09bdb418e3f76194633d591883fabfa5f20ead785d253f"
    sha256 cellar: :any,                 arm64_sonoma:  "c4c0c0aef3b106ed7d09bdb418e3f76194633d591883fabfa5f20ead785d253f"
    sha256 cellar: :any,                 arm64_ventura: "c4c0c0aef3b106ed7d09bdb418e3f76194633d591883fabfa5f20ead785d253f"
    sha256 cellar: :any,                 sonoma:        "114f230dfa16bfd0428b7354fcf24dfdb130f6cbad28ffe52233db26cdfa113d"
    sha256 cellar: :any,                 ventura:       "114f230dfa16bfd0428b7354fcf24dfdb130f6cbad28ffe52233db26cdfa113d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9b6799953913c4e4967360ddfde472666dfa3486351b667551de39c1abc83dfa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2a096da031ac2f0bcb0d56ac19bfc907c4aac95fa563dc291ffa2495c9710c06"
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