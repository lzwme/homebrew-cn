class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.94.5.tgz"
  sha256 "246307a4724a50655208530e6c07425f775a1f9e60998a9301ffcf4c343e7969"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "121eb984169013277e58b6675d6431e46b56c9d8c1aa0dbbdba103421ff1d8de"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a50a88327c207a45543a810ac52be55b06e6a9102a8eff24a5b0fbda5ea67d92"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "be66a4a81f53b609c67e108be5318638c116639fdbc6e69a55695195c70733d5"
    sha256 cellar: :any_skip_relocation, sonoma:        "d1f19fbe91e1da697e8665f5954237962b5da497ec5ef880795779d4fea0d350"
    sha256 cellar: :any_skip_relocation, ventura:       "ac1a14c863b54bc7ba8c0b8b029b3bb386b08f39d584044abcb610cbc15b7f40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "03d241578ed388e6a8025efd3dc814fc48285136f9fba51c17f7a56a5de43d9e"
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