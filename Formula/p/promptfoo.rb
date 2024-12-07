class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.100.3.tgz"
  sha256 "c572ecad04f7a3e891b7ae6e7d9881b7bfb01de1f25e3d42445d8e4c4067275b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5eb03e8314603d4fc182b0ed2f6cdb781d00e78cf56d3be2d7c6bfbe11ec84e5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a4098d2c4f18a50b5dea2b7d283ea6a786692dfae570d2fefd0396187b79cc19"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d64ba5c170488049f7d3eddf90cebd2a4439ebfe1b80e58df33d42f4aa84528b"
    sha256 cellar: :any_skip_relocation, sonoma:        "13fb3128c01f684342c7d6cbc2760036f88f981cfbc149b2ce6a7ab1670d083a"
    sha256 cellar: :any_skip_relocation, ventura:       "75d94c281373ed7c8a5363d460c1e0d29c953a6b0ab07721cb817d898bd9ba22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a94319940adf50438b0585efcbaf4e46de39a522f42d5f1630de6634f7076718"
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