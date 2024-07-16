require "language/node"

class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.71.1.tgz"
  sha256 "8f6b5f760c6b85794723263c34a4ba5022d0265c054a2598c9141bb982b1ae1e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ba2cff51360923423a37eb26729bde5790091572552b428074b4a3c47a4f98d8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "22f4f0693555d6b57678406ef26f7df4a828a2a0ea05ef774b773c6921a424c4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eaf8661924feff16ac17494c4ac67279cc9576b445081e3cc873ed8d8f0ed977"
    sha256 cellar: :any_skip_relocation, sonoma:         "2e9f5900e68f19a92beb2c1ede37429b6288f4c3c7ff80dfdffe648eb0163385"
    sha256 cellar: :any_skip_relocation, ventura:        "102b47de09a4c262bb72cf3cb27067302b05f8e5150154d72998e1ce70fb5e5e"
    sha256 cellar: :any_skip_relocation, monterey:       "2e47ad59284f7c3a70589be55e1f98c1d6145ac8c5ed28b038db5adf0780c020"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0e2f6b9d2431a65dcb16c002f978921a3204e6c1d4d5f86c19d30fabd21a3c8f"
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