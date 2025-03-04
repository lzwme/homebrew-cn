class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.106.0.tgz"
  sha256 "0d85bef0b1bc326ca9357aedfab64807531ec0e77a7b50467c70447cd0abf888"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e441588ff601837cde7e00be99f08c5411ba2bb190f9276ed49242c286c3a1bc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a0c78dfa701fc6777358452601e9bb8b21bd4ebce8b89a9839fa230bdf56652f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5652b772f8e738ad7f6a1a6a0b4b3f02cffa8efbe87ad84f6ba1273b20e0f796"
    sha256 cellar: :any_skip_relocation, sonoma:        "a493537720a9c1fbea17bcc95c23d70014c319a4e3220fa4a00645185edb3912"
    sha256 cellar: :any_skip_relocation, ventura:       "bed0f0886bd18816d5871939aba0d928c635d085542de4744beed954dd88424b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c01de320fec3258a608eee97eac7d1401f8ff81e22f3959affbfed8e0feb342e"
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