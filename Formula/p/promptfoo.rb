class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.112.4.tgz"
  sha256 "b5cb767c9d55c31d33e4ab46380a9d69a8228fb5cd1ad896edd819a976b61db9"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c5973f79a221c378423268dfcd1651b197dda077b0f8f70ca85e0f1512baf7e8"
    sha256 cellar: :any,                 arm64_sonoma:  "8cb52501c748772db15845372dad9645f1e32bb1a44b794ebe587dbede8f78f4"
    sha256 cellar: :any,                 arm64_ventura: "8d6479e3ac3cd82daa345d607ec2b766e92d9783114cb27bfef429830bc1dcca"
    sha256                               sonoma:        "61b2bdbf4aab3252938d3b0a3c9e10e984bfac89c577dad2da67a3541747601c"
    sha256                               ventura:       "e43851e22564d6346b3eefd28a3c4467de7cefa565963a00919f7488c23827e4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "be7d4fa9f4b581aeaaa39ac517e425edc85613149f36cf108bcb75270e6ef580"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0413776a9edb9482fd4ddd807304e86518263831be22f618f4a463320cf52b8a"
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