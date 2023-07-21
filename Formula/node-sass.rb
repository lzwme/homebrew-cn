class NodeSass < Formula
  require "language/node"

  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.64.0.tgz"
  sha256 "60ae28d7555f0a7ea4e0fd0d83ce956293f01d060014a9bc4c50e171adfd297c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "66107096ee2d78c8dfb54b142b8dea100cc436284e28650c7a6cb6e8c5760a5f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "66107096ee2d78c8dfb54b142b8dea100cc436284e28650c7a6cb6e8c5760a5f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "66107096ee2d78c8dfb54b142b8dea100cc436284e28650c7a6cb6e8c5760a5f"
    sha256 cellar: :any_skip_relocation, ventura:        "66107096ee2d78c8dfb54b142b8dea100cc436284e28650c7a6cb6e8c5760a5f"
    sha256 cellar: :any_skip_relocation, monterey:       "66107096ee2d78c8dfb54b142b8dea100cc436284e28650c7a6cb6e8c5760a5f"
    sha256 cellar: :any_skip_relocation, big_sur:        "66107096ee2d78c8dfb54b142b8dea100cc436284e28650c7a6cb6e8c5760a5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f95fa1d69952ff0aa582dfe918659d4a44082109b6f6e7f9170832e06cecada5"
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