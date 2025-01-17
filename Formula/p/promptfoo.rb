class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.103.10.tgz"
  sha256 "2f696a10d98c795c5f93785e72365a102e24f17749e2621a547b7760a18325ed"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9b7c1adc3881fa4c307969e320fee31504ac8de66da02968e0d89f87c2210583"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0540ec7bbd9d3d6f9cd32a5f58fd3f60ae1bac9a7b234a6391390db583acc750"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a64a675b36d7e73c786f3d87e5365337d1b93a85aeabfa8d344a802ee2142a4f"
    sha256 cellar: :any_skip_relocation, sonoma:        "9f9a0a908049f331d80b4971ec282734c9e45e261581c9a85cb48f2ca2d31641"
    sha256 cellar: :any_skip_relocation, ventura:       "ecbbfcdbd509fe3aee25760c1b87645dc5f80a41a0298365cde0e8e7df069157"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "436f052eef95aa18a9d975580e1e2903019d6974b7791afe5c37c164a654c738"
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