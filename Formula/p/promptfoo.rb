class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.103.3.tgz"
  sha256 "68a2ea0c403ba1cf5537d705394728a56d66123a95c34714cbb502deba9f08c0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c6cc03f50d8c7bbe533699f6231285743eb4918fcbc6ba7b5d39a3cf4008b05e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f3637adc56a07990d1352eeedbc7de7f74aafd7f3c2e5620eb944226384ac384"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "78e5f6527829d1e30244bca7aba1a418f13b260df5b2c6e5175ebdbeca70f211"
    sha256 cellar: :any_skip_relocation, sonoma:        "d3d5ff345c0611a7c68d020125317a9d8f53361b5639c7cf77d844749d74e6fd"
    sha256 cellar: :any_skip_relocation, ventura:       "049d7440dbee0d7e65cf03942c68464f04e2ab475782ebbd45170e262d40b346"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cfb412b54a2fbdcfd561ac4dbfd5e94a139121a7bbd7cf473a8c38c65d49beae"
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