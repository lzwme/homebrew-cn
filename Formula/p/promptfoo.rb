class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.103.14.tgz"
  sha256 "d760edbdcca22dcb7dbc396e57a678f938602eaa2d4e869f8690f4399144db51"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2ee1e2401a3b6474831a77f869ccd2e70926cac8163324a61cbcd4524a7af909"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0c84391a21461537f1e5fd82e9a67d14f5dba53558cb3258f766b4ea4d9f7d40"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4a93c8536cb33abf7e9ce64d7897cec19b32d37d5b99443e6604da626281d856"
    sha256 cellar: :any_skip_relocation, sonoma:        "869e311599beee178a6d092f9407bad489c5dbd6a8706b9e45035515a1e71d81"
    sha256 cellar: :any_skip_relocation, ventura:       "2c3ae4904b69ec2264af663dbd4d8d5bc30b914cfb72854bef2ff935ed08a735"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b0e027c14bee3950440dd8def481e5b25256b042f2247ba4f2f502e8928001e"
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