class NodeSass < Formula
  require "language/node"

  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.77.8.tgz"
  sha256 "27d467af0797116c5ecf21503bcfb4bed270724306846ea4fde360281f87af7b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "97bdb41539a99d3fb8304c78fcbfb8f2dc267fd0557d2864838c012f668a73d9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "97bdb41539a99d3fb8304c78fcbfb8f2dc267fd0557d2864838c012f668a73d9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "97bdb41539a99d3fb8304c78fcbfb8f2dc267fd0557d2864838c012f668a73d9"
    sha256 cellar: :any_skip_relocation, sonoma:         "97bdb41539a99d3fb8304c78fcbfb8f2dc267fd0557d2864838c012f668a73d9"
    sha256 cellar: :any_skip_relocation, ventura:        "97bdb41539a99d3fb8304c78fcbfb8f2dc267fd0557d2864838c012f668a73d9"
    sha256 cellar: :any_skip_relocation, monterey:       "97bdb41539a99d3fb8304c78fcbfb8f2dc267fd0557d2864838c012f668a73d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f819ee7c06a42dc1a525c6815c8434083b0fee5b626b7502173dbd7b0e0e17c7"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.scss").write <<~EOS
      div {
        img {
          border: 0px;
        }
      }
    EOS

    assert_equal "div img{border:0px}",
    shell_output("#{bin}/sass --style=compressed test.scss").strip
  end
end