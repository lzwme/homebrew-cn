class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.115.1.tgz"
  sha256 "1ad6cc3fcaa6b86320a015f41fa072266c629baa9c5c6409672195fb62611af2"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5a3322a90fc5683e86f054b3a64c900ca39273680fbfec2a1e786336c17620f6"
    sha256 cellar: :any,                 arm64_sonoma:  "f634c7f05d3a8b56210c3b62182398e097c93fc6727c55bdde9b5dc6a1dbee16"
    sha256 cellar: :any,                 arm64_ventura: "e2ddf6cebe35154a2e8275187de5a3b55f03e561f8a5971ba99742a7ee3beeee"
    sha256                               sonoma:        "57e8cb5e4ecf4b3365a386b0ff4ccdc995819fc4e7ae99bc22b23ca329e36e92"
    sha256                               ventura:       "7e875b60078648276a9d090df5c23a8e4de180a49f661787c5eaf9b0da0dd9b3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a83f83475144aedd82e6bd879a1143b63d267dd86fd444adf9c7e56d17680a7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d8b6586d5ae178d8674f733ad61f998a3644f95aaa52ed0c5c76e951954e4053"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    ENV["PROMPTFOO_DISABLE_TELEMETRY"] = "1"

    system bin/"promptfoo", "init", "--no-interactive"
    assert_path_exists testpath/"promptfooconfig.yaml"
    assert_match "description: \"My eval\"", (testpath/"promptfooconfig.yaml").read

    assert_match version.to_s, shell_output("#{bin}/promptfoo --version")
  end
end