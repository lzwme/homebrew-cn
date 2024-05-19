require "language/node"

class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.59.1.tgz"
  sha256 "5b2800089b20e408889415a281bb807a8a9e3f13025bc04937a28828ff158bc3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b31474be3b149f53b7f55e9235e4f9f23bb0c56a7c800d46d8bd10d22ee13f58"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9eff2116c7ab2510c6fb0eb13f1d3e7d45c314daac58902f8a9bf843bbffe6fa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9afac1ca726faf6db5ea51a26abcc5ee689326c325e8ce42b09daf4c6bf480a4"
    sha256 cellar: :any_skip_relocation, sonoma:         "3ba088644d4b460ccb75acb00496dd6e4c867885cec527617af2aa17c8dc516b"
    sha256 cellar: :any_skip_relocation, ventura:        "87b1c26d11c70d014954ea72c7e223b9402cba222038e4ff30907b22503b36df"
    sha256 cellar: :any_skip_relocation, monterey:       "ed95ad119a98556a6baba988558dd8ca5bbea10fc7fc6610e8a8cc74bb3c8667"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "728fae0e3fec4630efebe4fbdb9d5d25794b980a0d01a63ade3ff9478a341607"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"promptfoo", "init"
    assert_predicate testpath/".promptfoo", :exist?
    assert_match "description: 'My first eval'", (testpath/"promptfooconfig.yaml").read

    assert_match version.to_s, shell_output("#{bin}/promptfoo --version", 1)
  end
end