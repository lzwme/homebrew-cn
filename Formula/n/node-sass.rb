class NodeSass < Formula
  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.80.4.tgz"
  sha256 "feadc9f689b558b6ba59f2e6a6c37c1fbec1307c6bbb357afe6f6d6dcc25ef9d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "164036a607dbc47755ba7f0b78cb8a49dc3f54102bdde4969f447278b4159a04"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "164036a607dbc47755ba7f0b78cb8a49dc3f54102bdde4969f447278b4159a04"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "164036a607dbc47755ba7f0b78cb8a49dc3f54102bdde4969f447278b4159a04"
    sha256 cellar: :any_skip_relocation, sonoma:        "4690c08883a0eb062c7abf4e5bc8fe01090d8d967bad15ec2a41b3ac2973aa94"
    sha256 cellar: :any_skip_relocation, ventura:       "4690c08883a0eb062c7abf4e5bc8fe01090d8d967bad15ec2a41b3ac2973aa94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "98dd35c8fa88d165664b248050317f61aca4a3f4be7ddaf7c600c9b1288398a1"
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