class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.101.1.tgz"
  sha256 "5806203fab050095194fefe4d328aeea5f4fb966dc84986429f22750b3ee63d5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bd49ffc325b0ad5ad688132cb2dfdecd8a6ee377d4ddac9757c575ae446616fa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0784890867bec94af4f0c5a9dff4b5f9baff6ee26ce7befbca8e8fda1e94c880"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2e57a5ea41cea4e3106449e710a4093c77af78ffcb6e32f1411fafdacdbe5759"
    sha256 cellar: :any_skip_relocation, sonoma:        "07d2c5b50f89a644f6d947bc3d561b96db94735799528d305bc552bdf9a31bec"
    sha256 cellar: :any_skip_relocation, ventura:       "9e508b81b3313262733076917333268913ba4f2566b14cc237520b6575772a30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c9ca094c4389be2d97cc8398042cb94fc4e058cc70e95607cdbfe30e592da61a"
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