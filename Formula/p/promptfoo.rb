class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.89.2.tgz"
  sha256 "d9c3cd0d1c02f87721aa3a2fd5af5d66740650900834ecd6e93835be7e39ce87"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cf79af546cc01bf2f8d231e226a615db404167fb4d5122999552c725fcbbf7bd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "69db87f2895bee6e2166dc6d9033aaaaaaf0b961c84bdda97ccd3e42fa9d737b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "af902fb10afd2d49ec9ea1a737ee895956494364fc013afc4c5711f1cd861189"
    sha256 cellar: :any_skip_relocation, sonoma:        "f878db6c3d59930eae010bf9830ac3242753f4815f2868d15d60c36b7522700d"
    sha256 cellar: :any_skip_relocation, ventura:       "7694d513549ce06984cb81b7582d20a0e87a7acf58cffe7d389450e97e81dd3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eccaf17e2076830bf6014839f9d5ac66e6a2cd3042a49d3e875966b9097f0d05"
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