class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.94.4.tgz"
  sha256 "901635ae875efd0cc6f419b3fa6553e70b8e2f26d34eeeb465cb99fc3b11fc36"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "44ea53beb005254ed460a3f2584113019cfecb2ff989365a7b54774a2ef16dd0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "27df9b7aa52b32d950a19569d0e0788c127a576ab9061275495b0959839fed77"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a7102b2e83d62869f7b23962e4dbeeb94bbfb9aee26096c0ab280ad4ab8c58d4"
    sha256 cellar: :any_skip_relocation, sonoma:        "e0fb5e06a90d999d364d553d6896d82c2fcd622530ad871a68216068fbb4b3dd"
    sha256 cellar: :any_skip_relocation, ventura:       "df94a593a7204ccf30afca4da3163fbb56323000bd6676b1977116019b0a136f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "70af85f7a53ef1ccd408d35b8aa24705ab4556ecdd02922347d64834dd5ed054"
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