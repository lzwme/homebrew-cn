class NodeSass < Formula
  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.89.0.tgz"
  sha256 "fe44bb946982a0937c15414aec899765c8050f937eda453b2324b27e37a94582"
  license "MIT"

  bottle do
    sha256                               arm64_sequoia: "0fa848a9dff53d98003669d9afc8f6cccfd3cdc4d92adc9391745701fea49802"
    sha256                               arm64_sonoma:  "f7453e2fefa41706554de2463511a6cb7b36a97dba80b6e9e54c1332d38db922"
    sha256                               arm64_ventura: "691a3ad80f0ce34b07d72d5f8b9a6ef23edd01783707bb621bc4b4e9c8312486"
    sha256                               sonoma:        "be94e45f971bd0bfc53ee26f0d544c9d12839cdf0b7d5ca709e65a6f96fe8092"
    sha256                               ventura:       "74760b4c14b4ec27863e6bd88c33290fd0440823a10e946c929cb5e6110209a6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "64c5c3beaca3051e6bcba421c8a5eac00023bbe1e77395267727ec08f18b95c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "33550dc1f9ff53e1330da1188e3f30f351422d21470c11fd8fc4c52e12240c79"
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