class NodeSass < Formula
  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.80.5.tgz"
  sha256 "79b67bd480565aba16755e6ee7e0b843f6ef39d8d099ab458974c99dd2696401"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fd5f1687e49313542e0c75db6f95d5d3f9ac991f719a06fca547097f820ea2a0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fd5f1687e49313542e0c75db6f95d5d3f9ac991f719a06fca547097f820ea2a0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fd5f1687e49313542e0c75db6f95d5d3f9ac991f719a06fca547097f820ea2a0"
    sha256 cellar: :any_skip_relocation, sonoma:        "c79a2f26a077e9368a83826a9788466b9e5f0bd1bd1fe16dcc4c38cc8023adcd"
    sha256 cellar: :any_skip_relocation, ventura:       "c79a2f26a077e9368a83826a9788466b9e5f0bd1bd1fe16dcc4c38cc8023adcd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "97afd485b5e18726a437c4df1e2c03af39f427e2d6b0a535e25307e3508ca141"
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