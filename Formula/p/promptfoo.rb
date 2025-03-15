class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.107.1.tgz"
  sha256 "922faf2e4dcd5f1efd69cbbe84688e04d30c50e768227ad163b73d21d5905c50"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b5138e2d77d77eb4dd7166a43aa85bda377aebbf7c96b9faa517e3f6150c64fa"
    sha256 cellar: :any,                 arm64_sonoma:  "5f135aadc873a0e7b357c3d0ce56b62c62e4723caa5b419fa24b6f7c51c8aa7f"
    sha256 cellar: :any,                 arm64_ventura: "38c91de2c54763bc5c15443e775947ea22024f9fc8a0dd12415651cf868b617e"
    sha256                               sonoma:        "ea83fae169e99ecf7d9ea478efe9159f6b8024d9f05467b088191555eec656c0"
    sha256                               ventura:       "c9e47f65cd2e37eee61e71af30d4b4e3dbea61ae7dd6bc27f782e9e3e850091c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "caf9ca1e2d43aa797cd1d430843ba524eedae9ca4bdd1b976313e263f73e4dfb"
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