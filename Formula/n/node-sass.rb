class NodeSass < Formula
  require "language/node"

  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.77.1.tgz"
  sha256 "787755c748a33e95a760b529ee39143a4751a8cc0dba1b17ecdd8dc5f267f0b3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7f699706413f985fdeef65c46bbd433be31e266d96df9509ecf19a6c9b9fcc07"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a951235736bf793e80523eb43ebaba2b14c5b74cad5e9b8278b50cee7bea9ceb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b162fc9e5c02dda7e3ed73812450c60d78655c9b0dd4a3617deddbf676ed3734"
    sha256 cellar: :any_skip_relocation, sonoma:         "9c3f5b55482f58a285d8df4cf7fe4b36687d41acecb1e874bf5cc5d5169ca470"
    sha256 cellar: :any_skip_relocation, ventura:        "9ee6c88c7ec7bb3435c9c0eff52318515bf8bd709543ce4a72902f563ca6e6f7"
    sha256 cellar: :any_skip_relocation, monterey:       "0522f678634e61c59cdd528b086df6567cee344d7d91c7dd081ebc045d5cdf5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3e30f64c8b1e13c82d065e6873aa4b7978a77497a81ba77e39ac7881a61cc2a5"
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