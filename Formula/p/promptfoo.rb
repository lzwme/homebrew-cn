class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.102.2.tgz"
  sha256 "2eaeda037975e826a511721fab2950e503b65b614e033068f72f93201f6bf2d4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "940b088f5568be6fdec275a04809b715d02f7bae9526e258dfc047370f02fc34"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0619a48288b7f466be5e873fa4c5c8e3300a6af984b5cbd797740923e3958ac3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "737225d2a13a8dc8a989713fb5fc6b581f5b6eb71482307ee4e7f74dad0ea498"
    sha256 cellar: :any_skip_relocation, sonoma:        "2f176e942badcea550cf140a9a57b10eaa40b142ecb4d988fb13ea090979e32e"
    sha256 cellar: :any_skip_relocation, ventura:       "c25f6745fdecdcddd4ac9629a1d71c309f9e6ed7e47e184ebedb39b5b81da377"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "24e37922557b0fb980017ef428f6db2c205cafa6adfbd8fdc9e7dc1a88170d01"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
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