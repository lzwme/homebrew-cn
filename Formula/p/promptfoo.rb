require "language/node"

class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.72.2.tgz"
  sha256 "650826fd7e085f2e16dec37d7799933439f35edebc4eefc290dede0bd62ef8c6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bae9581ccffb2009029ba1bcb387e332d2dda6a6f7e3ed94b41198cd9fa4621d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6dbdc2c8859acc06cda4130c17e21f933d97f9ba63274203f2f8fb13ce010f7a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "26a6ef4df5246537550d48751aab604f591d5c2f1d4fcc6f8f71cba3b46eb533"
    sha256 cellar: :any_skip_relocation, sonoma:         "e1fbc39bd49f1f5d00ed65d620d312a86a8937273d42750129d99e1a586fe6b2"
    sha256 cellar: :any_skip_relocation, ventura:        "ccf2d03b644a23ebb868c716cc344c39fa125aef374d9c0ed85103dc5ce05380"
    sha256 cellar: :any_skip_relocation, monterey:       "598a1cc5601a0729993bf945de71b8c81b20c9c7aa4fc37f213420829a524026"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "939e7a4e999533df1ae5d28b1b9275fde2d18012224eb3fcf8a8ecec1493ba90"
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
    assert_match "description: \"My eval\"", (testpath/"promptfooconfig.yaml").read

    assert_match version.to_s, shell_output("#{bin}/promptfoo --version")
  end
end