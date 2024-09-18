class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.89.0.tgz"
  sha256 "bf84c404fce0138bb2743693003613274a416c6efda9c60afe53de02effff414"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "db8824b0de6e4d991701fb49310f2c8a5c79ccf29a49b5dab2fbb99291a0b6a7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9a0e868f99d5a08fe63b0adbc908ce60019c1853a1d8160c9c71e8312e1aa0a2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8a54673303868bc1f0267d6c702f4e528b5f4ec3392d13e80c10d179533f76ab"
    sha256 cellar: :any_skip_relocation, sonoma:        "c94cfc747433118560ec31129f3d21b3c9cc66275d79ec32da5d6d924b1dcb1f"
    sha256 cellar: :any_skip_relocation, ventura:       "5a8496557a7f95583c851532f6c7b16af9b19848892a07e9db31921b052af9a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b4ef63e68e62acac5cdc84edfb4ad0d128e660435380bf65a7af93edacfe7408"
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