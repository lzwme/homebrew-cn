class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.91.1.tgz"
  sha256 "7e09a70fa8e5d39560a20c85bcbab663225b69ba34a3a33ae1c5dc5bd9947a2a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "58d6d99b2d44db6175ec481308ba614a1266c0f65dd69ee313a4ed41561f7082"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e96a272ea805e9540e2081bd1dbc8a3355272a9c3cf6ab2d67b0a174a6d22e99"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7f56d9e7b8275c83c5001e76f1e2177f6f550f0f855c45a77c281518f246638b"
    sha256 cellar: :any_skip_relocation, sonoma:        "fb4d5b946727c237eaf183045de59b64bc39a965451dab1eba4203d03a915ac8"
    sha256 cellar: :any_skip_relocation, ventura:       "ab90d9b10dced51b105b2dede465221bc81fbe859c34273def8a49e255451d16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b4a24c7d2452d216cdb3305f4e76dd3db374d44c431c35da9fc4eeb6b736fa9"
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