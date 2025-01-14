class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.103.9.tgz"
  sha256 "dbbfe7f2de49c7c2b53c50c2b6da58d0abbe0d724772deefb9b362ae4f5105ca"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "142adcc86a89291fdbfc902f1cff54138ec4f458b45bf793eee2ce3892aa2eeb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d581da73dffcca56263f7277e0dd62388bb01933ff9dcf20300737c1ec4173da"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c4d3d28830135165b8083a928eefd150ad55bbd69f8d8c49d0e06c23b4cda474"
    sha256 cellar: :any_skip_relocation, sonoma:        "905151d0bbc96bc0ece93c6ae42a34d0f2cb9648dd9388e6d775ea45a054c53a"
    sha256 cellar: :any_skip_relocation, ventura:       "85925c84af90824fe11129abb9bfc29653714ba91ca2b1eac523006ebad30a57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4214a6784c1c2c8e1522442659d401629072a5390fdf520f171ebb0e03792119"
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