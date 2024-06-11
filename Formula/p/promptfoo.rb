require "language/node"

class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.63.1.tgz"
  sha256 "8f8f144ef218f4e2ad25bd1de40845b0c7fba07236b170ccbd3a87cb970a4a4a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "72fdb9edccfbf9ecca97814af7bfad94f88c4701d1cb67afaf5235ce643fe790"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f06a7fb22a1d48f226907aeb929ff6d8ba9eca41ce1f69e2efa3884e4b229218"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "50f33a1623d26b4e753eee4ef8481504e3014f507860b5c368c50ea95d0f52e3"
    sha256 cellar: :any_skip_relocation, sonoma:         "4944f6228df3ece7267fada3ca4f96a0416e68db88bd85dec636e2612cd4e0ab"
    sha256 cellar: :any_skip_relocation, ventura:        "828d13700e06c9f711c3365e0bfc58d1d45002efe0d077cb9029323640d8dab4"
    sha256 cellar: :any_skip_relocation, monterey:       "b56ef8d6fbfb44183f8acc7af4208ff8061ac6b04606bb7877b2336a30edc5c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "efa63c0b4c429155d2a0889e640c5fa8d6cb2a0d3ce905d4c3e7873c410fb779"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    ENV["PROMPTFOO_DISABLE_TELEMETRY"] = "1"

    system bin/"promptfoo", "init", "--no-interactive"
    assert_predicate testpath/"promptfooconfig.yaml", :exist?
    assert_match "description: 'My eval'", (testpath/"promptfooconfig.yaml").read

    assert_match version.to_s, shell_output("#{bin}/promptfoo --version", 1)
  end
end