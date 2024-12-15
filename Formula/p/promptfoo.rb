class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.101.2.tgz"
  sha256 "0767bc00c441bbee952131509f1f1c2539e974d7555235809eb28538a4e1575c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5fae6f634278dd7c9546b4c6227cb1dcb7f4acd825be658dd0295a96656c44e6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "20a73bd0e14c37e7db3e46db40c3e7780f7632aa2db4da1cdeb12cf4696cdcb0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "aacd0545049db5a08dc326e32cce071d8b278b6618a870c435526681de184dc8"
    sha256 cellar: :any_skip_relocation, sonoma:        "406cad5aeaf8b38bf3ff86c8c41d3ce4dcfd357b9e50187c49f07a5972624247"
    sha256 cellar: :any_skip_relocation, ventura:       "2fbbbeb76ecd88be2663cdce804f1db60628ff0650be68f885ffade1fe518abe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ed4f58448c3b47a8c723613993591c4d0f3c12bbb149557d3877bc632486d9a"
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