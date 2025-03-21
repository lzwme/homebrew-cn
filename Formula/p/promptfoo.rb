class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.107.3.tgz"
  sha256 "de742119990895824b3b3daef7e7c149c350cbb5b9a1c67c5d57003e07a01531"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "927789b73db5f1ac20f8c076ad2b9bf36f73ca26fd4daf52e29d89ca8b4a4675"
    sha256 cellar: :any,                 arm64_sonoma:  "0f0576924aaf8ab4492e7bf6aa18b2394f18e524c20a927b8a48f9dbc0d0db4e"
    sha256 cellar: :any,                 arm64_ventura: "9613265676f76589c5b9842c7a6f982d4f1db3e584ed6e10cd17fcd4aca4a3f7"
    sha256                               sonoma:        "081a18946179cee9628eee42125aaaed1764f3e18e8d3a31b50987769a9f601e"
    sha256                               ventura:       "37c22425e2822b37fa5319acd20a47f179cfac06a268859a3ddf9d8730505946"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "66b20b1883ea2f4cf17e030c96bb51255e077e6b99e723d964b1c0fc0225bc56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "190610e16a4789aaf6ff7e37d74b8682126d0112c704e7519c26d024e620fe40"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    ENV["PROMPTFOO_DISABLE_TELEMETRY"] = "1"

    system bin/"promptfoo", "init", "--no-interactive"
    assert_path_exists testpath/"promptfooconfig.yaml"
    assert_match "description: \"My eval\"", (testpath/"promptfooconfig.yaml").read

    assert_match version.to_s, shell_output("#{bin}/promptfoo --version")
  end
end