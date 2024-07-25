require "language/node"

class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.73.5.tgz"
  sha256 "9f421fb8706661942dfcc2dcde34f4e8d2504d8f4c6f1fba485838a9aba71d00"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "294cd5c859afccddf1a469cc9b7cf0bd7dafa5b62ce0dcdf2ab8dadb24c5d4ce"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a8f9f08857e75060e85de06ae181ebace67edd4c333335591a1c91339904f718"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d2872039e05851d2eee90ea343d93c10f1405bdecbf3f418d647a2c9678f8267"
    sha256 cellar: :any_skip_relocation, sonoma:         "e30dc4f5703d6b87546dbf654b3564b66b973683d61d3944317eaf7415222bb4"
    sha256 cellar: :any_skip_relocation, ventura:        "bb9858a88c82fc8c45cfaedb83d7603efe6cefb7dfa026cd324f237e4c49fc91"
    sha256 cellar: :any_skip_relocation, monterey:       "d41880e787495dddcfe3618b19a3cfe7cded84f84debaee8b12400e2ea5a0916"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a404ec0b29fdad36305edac0b9b3b796cd54dda7e3a5b1db9595511544f2fd21"
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