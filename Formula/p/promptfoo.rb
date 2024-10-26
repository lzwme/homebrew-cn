class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.94.2.tgz"
  sha256 "a3c65b75042a4eb23c10ec95b59b145838fff8a1979dbcb74fdea46dfd7ecfbd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5262a8646fb903a27beac2b5171b0a607c1833d928cdcbc341afdb16859d7cdb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "28eb80ae918ef45743f924b751c70e94131493621ec140cc0166a85d9ebb4534"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9692272ddc51faf0795b07b0d92b8d87a1ebe05fec23287404bef58300fb7f84"
    sha256 cellar: :any_skip_relocation, sonoma:        "ee266e6eb695a0d78727a51e7e029c6d0d32a0331760f777a407ef5af1eba629"
    sha256 cellar: :any_skip_relocation, ventura:       "84cadba685243f59f5359f7a17a64166f53a8a295aa6bb143eadb42fa1946337"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4878b661623aa569affa3976198a2a637decd01547061304d1f5b77b5569de17"
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