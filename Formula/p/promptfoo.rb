require "language/node"

class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.55.0.tgz"
  sha256 "bd830a821789fe56c1ed2763d3694c56b3c65d26ac3ec2410e84d67dbe700407"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9dbe80fecb7907ddee53b06cab052ee6f69eb035f5cff01566451999dec6136e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "abc7b2c1cbae6984d0eead88f20d49134c83471d549a18a09ed1c74bd34cd1f4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ef4c46979fa4ed040cc9901758c5c2ec28c7b61bb7c9c8a936a833ed4f913bc0"
    sha256 cellar: :any_skip_relocation, sonoma:         "1d65aa913a54b4ad24522163f59296a8e2c05254332392c14e7878cd995cfdb3"
    sha256 cellar: :any_skip_relocation, ventura:        "8ab6b9ca4233d454aa7f8b1aef918ed9733a6ef07195efb0917f40f728827093"
    sha256 cellar: :any_skip_relocation, monterey:       "fddd84592eb5955fa8faf8456b51d2244552f0e50aabc2ff0bf369a6c71fd4c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6967e099f8ca60930e9829edc4e391377a82d656b502c190e8b0f885e476a052"
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