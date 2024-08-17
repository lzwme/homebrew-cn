class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.78.1.tgz"
  sha256 "b23002fed23d0711c1b774be6217322028d5fe1c5e3c9be6c54de95de6012ca7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9a0af83ea675b0e36df9ee8d70e92343b31c08d7fac2a331b5ca409d767beb06"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f5636f2c92f4cc8accc38872865e611df4a0d6e9ebcde38cdb5490f8e3b1b8f4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4a6fea5047acaf63f19ca20c05e60cd7ae7368bb19dd3fc44fd7304e0c477bf6"
    sha256 cellar: :any_skip_relocation, sonoma:         "78040f83d96e12703c3de9cf66c59171179c72e0c5a4659346516a4a5ecda1a6"
    sha256 cellar: :any_skip_relocation, ventura:        "3b0e457214eb416c2954d0a9ceaa7d3234ef6db798fbcd431be09649c54f6478"
    sha256 cellar: :any_skip_relocation, monterey:       "04f8534aca6efc9e6b9f76756c9adf868a9f7ab885e32a285205ae7817fe2d0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fcece3e1c021b45f2a8969e088a8874f0500753ae05c8f51f998e65f7af8cbcd"
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