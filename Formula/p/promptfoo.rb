class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.114.7.tgz"
  sha256 "c11119844956c8b61240d2d95dbaa225cf8af1516f98d404595c43cc71a777ee"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f9b3ff3392a278f66ed5432d41b65b4a17c99e543976219731a730d9c7ca81b1"
    sha256 cellar: :any,                 arm64_sonoma:  "b154822281d15f8841ac7a8476c3c60279c5da752cb2b40115845aec6ea88ebd"
    sha256 cellar: :any,                 arm64_ventura: "499772fa0da9d631feec5467f35ac2e576d302a6265d85596dcd30f92154da34"
    sha256                               sonoma:        "596224b923663f3ccd58b11890c7c24add51f092a78398f85ceccf35379547c0"
    sha256                               ventura:       "cb2ff569e358f68496504ff97f715cd1472a28d1600c9fadb0558ec1ce9d3da4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "37a1bdde70c187a512e5da1709f9670040c64c2af63ea8f6d79df64f49070807"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "32f9409a1056ee00a5a00486edab9117a1d01d0b1d7c4f9c6e1a99667deea722"
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