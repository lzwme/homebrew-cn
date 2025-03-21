class NodeSass < Formula
  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.86.0.tgz"
  sha256 "b850deb9e16099b7b779bd5c9ecaf6ed9117de8853e8c4412715ba3f2991a669"
  license "MIT"

  bottle do
    sha256                               arm64_sequoia: "b4a2213c757908ce738343416026d0d0cb246707ba4c4490f7c46ce476799ee4"
    sha256                               arm64_sonoma:  "e8884a19742b2f6596b17fde04f0a9b1b172c59ce52966eb6a3b9704555be2b7"
    sha256                               arm64_ventura: "ce5fdb2e9dd04e2d49a39b618381a35c771b440faf44bbaa065a407bf4c3d50f"
    sha256                               sonoma:        "5a3b9753c753a0d6dbc2917ff8b9fa0b4189c1f5444f7115e5ebc843adbc3615"
    sha256                               ventura:       "8880096ef87b76f04905883d4f673ab01098b1ac26b218f6c0117f4019cd9c4c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b07f2f434f35f35ed6aa76ae14997147da95c36e6f7800901b21edf3c4d8c38a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "77a8c43c297dbf45bdc9d37ca2c9125ead27260aabbb4dfad0160881ee4ba447"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
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