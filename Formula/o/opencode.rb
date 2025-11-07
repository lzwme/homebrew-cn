class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.0.37.tgz"
  sha256 "fa90db2f3da42e6f53de1bbd3b27e7397de98b70114b8b92c8ab44e17f22e153"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "e79be81ce41fe03721dc9aca7f153980a38119cce52f8de8583053e318c06159"
    sha256                               arm64_sequoia: "e79be81ce41fe03721dc9aca7f153980a38119cce52f8de8583053e318c06159"
    sha256                               arm64_sonoma:  "e79be81ce41fe03721dc9aca7f153980a38119cce52f8de8583053e318c06159"
    sha256 cellar: :any_skip_relocation, sonoma:        "d2d28ea718963d2ad09e1609c7033a07088644945bfcee91b25156b9be3c1b9d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "49143caefc9c9bd9594939d981a83b4316550479ec3385aec23781db9025d833"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a86fbce5c48c3a7637b7900d87ed952dc66cd86fe1b81292e0832a4f8824dad4"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/opencode --version")
    assert_match "opencode", shell_output("#{bin}/opencode models")
  end
end