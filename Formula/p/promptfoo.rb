class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.76.1.tgz"
  sha256 "c9ae33ea7f037fdd9af2c04dd04e2e1915bb644a1eb7427a599862f6e30a3f8a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "26deeef5f0fbbbbeb548ad6ff7ee031b0c34c73aa7af05a0229a59c040e35554"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d07959dbf4aa7e406c4b289aa222575e6b2b90cdff916d7ced429d5e81353d90"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "768c953076287fa06bcef0234f61c6a459084a24e0dd63e5d4f037d03ba3b50d"
    sha256 cellar: :any_skip_relocation, sonoma:         "ba450718bb07d5dc8e6740bb59e3c69f645870caa5b5745f16b85c2e46aac261"
    sha256 cellar: :any_skip_relocation, ventura:        "b41fa77ee7d6e73cafad610e1bdccbed922b2874e1c6baebf62263223b39cf5e"
    sha256 cellar: :any_skip_relocation, monterey:       "46c39175589f40c285a18b35c56ac7d433e60ac2ad709797e3837864050485ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "381351c4dc117fdef3eabe0f1493830afce2b6714899abbfa9e7a01f6792a2f7"
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