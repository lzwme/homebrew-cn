class JsBeautify < Formula
  desc "JavaScript, CSS and HTML unobfuscator and beautifier"
  homepage "https://beautifier.io"
  url "https://registry.npmjs.org/js-beautify/-/js-beautify-1.15.2.tgz"
  sha256 "268e43dbfcaa8056ae6947fa1085a4a354867cfb3ae170f875b3b5897fde2a73"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "29e9aedce3dab79ba2935272623a0cd2fd1fecf179d47edcf5f1eef551886f2e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "29e9aedce3dab79ba2935272623a0cd2fd1fecf179d47edcf5f1eef551886f2e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "29e9aedce3dab79ba2935272623a0cd2fd1fecf179d47edcf5f1eef551886f2e"
    sha256 cellar: :any_skip_relocation, sonoma:        "8525811f74295d714605fbc23bba97c666608b2868a48b88f3fc4c748e8ee7d6"
    sha256 cellar: :any_skip_relocation, ventura:       "8525811f74295d714605fbc23bba97c666608b2868a48b88f3fc4c748e8ee7d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "29e9aedce3dab79ba2935272623a0cd2fd1fecf179d47edcf5f1eef551886f2e"
  end

  depends_on "node"

  conflicts_with "jsbeautifier", because: "both install `js-beautify` binaries"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    javascript = "if ('this_is'==/an_example/){of_beautifier();}else{var a=b?(c%d):e[f];}"
    assert_equal <<~EOS.chomp, pipe_output(bin/"js-beautify", javascript)
      if ('this_is' == /an_example/) {
          of_beautifier();
      } else {
          var a = b ? (c % d) : e[f];
      }
    EOS
  end
end