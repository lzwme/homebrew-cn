require "language/node"

class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.65.1.tgz"
  sha256 "bc3c6d8b0e8c11f53a106bcbdce91d47dea4ad15153dc88426d185f8728e35ba"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3108201d2e8237187930b9ac38ad89a8ce29e85fe56cfa399dfa7202968fd06a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f288de96cde704773712562098197445d34fb67314e4b41619de5e1262d29f1a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f684bac056bea5cb97010998139bc1a85b0c7acea13816476ac842bbb464e6ca"
    sha256 cellar: :any_skip_relocation, sonoma:         "ff0da9fcefe5c897b15874f939fde9437b7fe704d819cd584dc9ed3b86819417"
    sha256 cellar: :any_skip_relocation, ventura:        "16658ba7aa6a5633d34ef64a018630098c9fae3b55b0a254b8b1727520d9df3d"
    sha256 cellar: :any_skip_relocation, monterey:       "f59defc81b35fc6aed40b76a58b8a2b937dddccfa8f5d8e3b623e7fa5f51f02f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "21179c92f6c1a9d2c67e1c4b4554bc7b9a5d0d3dae7d07e9fee82fc7bcc6b1bb"
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
    assert_match "description: 'My eval'", (testpath/"promptfooconfig.yaml").read

    assert_match version.to_s, shell_output("#{bin}/promptfoo --version")
  end
end