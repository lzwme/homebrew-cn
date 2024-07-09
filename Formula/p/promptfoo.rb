require "language/node"

class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.69.2.tgz"
  sha256 "59ac54bc640f2cf291fe5b4fde25c4d73940d9e04cd565cfdc6f9314dc8d5c58"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "43f893a3f48de1abbb2d8b7f90c2ba86bdbd9106265b9fbf6837d26fe045553c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c7bdcb6979ab45b5b20ac7bf13ed4ba914a857d9ca782faadc6425e9c223f578"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f43361273ae0ea756d0a505c1347286f6572898f687a0678b197f695d412a6a3"
    sha256 cellar: :any_skip_relocation, sonoma:         "206afdf69242f96fc5195c16f8f52a9cdc69b5cd5bcf74795550b878cb941b6a"
    sha256 cellar: :any_skip_relocation, ventura:        "acb3125616ea4d8b8c352e6d687eb146087cba26b15bae62fb336cc806362761"
    sha256 cellar: :any_skip_relocation, monterey:       "996e9c4c0f4c3a7cdda3fedc0fb2688b2b348a1321c6d2d5f0067e5a542f63b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6ec59e5e386590a5b8f04c3a09b07c7d005ed9a3b074e44471c05fbe78694d6f"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    ENV["PROMPTFOO_DISABLE_TELEMETRY"] = "1"

    system bin/"promptfoo", "init", "--no-interactive"
    assert_predicate testpath/"promptfooconfig.yaml", :exist?
    assert_match "description: \"My eval\"", (testpath/"promptfooconfig.yaml").read

    assert_match version.to_s, shell_output("#{bin}/promptfoo --version")
  end
end