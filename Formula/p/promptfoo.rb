class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.88.0.tgz"
  sha256 "5536dd84d8a8f21b7ac3ac4cee978d81e9d7622cfe84dbe58902dbfb296117db"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4f671de3c5722c0c14edbe81fbc3f88b3161d8493a66492ed59f90f78be66cfc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "15640e5786ee02068bcfc43cc3706fca0e5a70b488b420b6d632e99803170e84"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e3bf736e93058d667604bc7dd5002093466af0cee84c4ff50ac8016a8f8a1936"
    sha256 cellar: :any_skip_relocation, sonoma:        "4fb630ffb5df20a66d8052ceda3255a1224ce1a4f9e194a27fb21296bd6cfca5"
    sha256 cellar: :any_skip_relocation, ventura:       "e75a4d08f10e3d0729eb5e918b34b38e23da08690ad666e10d3620413b9a014c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2066f08a09ea6bd9f5401eff77157d9eb3e47af7f18d28258f0330002a0f2551"
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