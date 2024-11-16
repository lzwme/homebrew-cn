class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.96.2.tgz"
  sha256 "774dc8f4ff5ea5e7d70c29f021709f46d5dc87a2908d6d409a247ae801a6e474"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "24a928c5aae02f198e3651314c711c05d38dcf24896e123c356032d31a09d433"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "87600acd7825e20713fb75c277cee9cb24fefdcb6a2e2bcc812f499cc345078c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1ae959d92776d03864f24096806cc154f165d6f8d8359e11bda869f304430306"
    sha256 cellar: :any_skip_relocation, sonoma:        "9635e8bd80cce74dbd5fa7cdba335d58b80485a3e2f064e2111bca06bdd0d16a"
    sha256 cellar: :any_skip_relocation, ventura:       "87dd9668d703640f5b445664fbb52158fbee93811306aefe8c95ae0d0c98873e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "774b213d926773e3b02a4e8e96967f3da964ab8fba270eb10f917e964a5bd8dc"
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