class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.99.0.tgz"
  sha256 "bce3ee45a278b66ed5dd5a8e943fe9829c0a190eb831f9fdab1d37e2a73e02a2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d27c5a87418774b017948f05c2cee209200f557bca331ea0069e1bcf319cc17f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d12df67fa3e704d081dfb6320c19b568a5dc14dfbaf587d310f9482da84cccc4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "69ca614d08a96a5410ca139c62ff4d14c6242b3211a602c832dc84cce5e40fa6"
    sha256 cellar: :any_skip_relocation, sonoma:        "2cdf8cfc841b1ab6e4b33a78db44e9a4f1c6f4f1376d26efa5562b2be89151e8"
    sha256 cellar: :any_skip_relocation, ventura:       "8c7396b02b8df694f5e4be443c1a488dffcaddf4c085b33a64f2223f37e5a311"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e59189eac1650eec6996d4f3d53405fd73efec4a2eecb4659f6e204fe46dc21e"
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