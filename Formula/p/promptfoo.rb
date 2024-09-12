class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.86.1.tgz"
  sha256 "7c51896c0b4779f8f51ddb357eab841cb20496b21a12b49e6123fdb07de6c742"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "ae9289bcc6d15371d0866d0271f77c024b4ae6212a7f1434149d4edc695201be"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d2d50081277c852515ba241be4cc4124e4a7f30a9c41799b2a781f3bbc80abf3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0ebd12a2952f16359be95e0fbd45170d5b3afefcf05feb499d1fb5f94d717bc7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b77686fc2c057d969a4d6973eadc82b33d15ff182989c6decf126cb05265d130"
    sha256 cellar: :any_skip_relocation, sonoma:         "8a848cf818f7e918ca77cbd0abe350cf634baa3b1642bd3d6b94c8fdaa65a070"
    sha256 cellar: :any_skip_relocation, ventura:        "b8029b4cfa663f136086df6f45865a424b0111bce98d2a7dab75160e22784cd2"
    sha256 cellar: :any_skip_relocation, monterey:       "4d8b772466c8ffcb08d5fd300b31b128b3b1341cff4113fe4e8c0f12db14fb4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e75d131857d1ff40e06661ecc22772ac330386211f16cf2052add986445240b0"
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