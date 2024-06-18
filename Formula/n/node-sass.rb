class NodeSass < Formula
  require "language/node"

  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.77.6.tgz"
  sha256 "faecc5e299051b7b5d4635a9c9d0b723e09a75895937483e1b1ea931f1d1e682"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "82a6e1acb751074632c0471877a6252b760c50425500ae5e3471f216fa718aa9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "82a6e1acb751074632c0471877a6252b760c50425500ae5e3471f216fa718aa9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "82a6e1acb751074632c0471877a6252b760c50425500ae5e3471f216fa718aa9"
    sha256 cellar: :any_skip_relocation, sonoma:         "82a6e1acb751074632c0471877a6252b760c50425500ae5e3471f216fa718aa9"
    sha256 cellar: :any_skip_relocation, ventura:        "82a6e1acb751074632c0471877a6252b760c50425500ae5e3471f216fa718aa9"
    sha256 cellar: :any_skip_relocation, monterey:       "82a6e1acb751074632c0471877a6252b760c50425500ae5e3471f216fa718aa9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "de4daae4c5631287fceb4ca759bcbe3833eebc310edbcd3df40acace78577faf"
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