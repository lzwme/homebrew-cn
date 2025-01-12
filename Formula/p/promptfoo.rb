class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.103.8.tgz"
  sha256 "a085f278e1c3abfe52d3234ee027a46efe178b301976ad1472fb4be1f35655c7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2c8a7510f607d3f335db73c939aa7acd2d7eb6f53cd7e2d026aa14c6efb005c3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0360e0de2fa614412530b63d7c15411bd97586e02629db7b000973c0637a4e31"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1ee36d4d345b9a948d0e519ec12da9569bc5b0cf5ecfd9ab5cfec6b070c5a05e"
    sha256 cellar: :any_skip_relocation, sonoma:        "82bb408966aee371bf7721e7eb14af8f06f15c108f76ce9d6687f3a9d2298443"
    sha256 cellar: :any_skip_relocation, ventura:       "92572457d62e4cee63ab04a5ee58204356ee819dc541dfb09d8ad6acca63db2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "809f89ae988f6195c11da0a1a831eb86c86945c684a66e16cfb78ce884c426dd"
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