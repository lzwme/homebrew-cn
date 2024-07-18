require "language/node"

class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.72.0.tgz"
  sha256 "073357a1cbd83f0cbf477377583667af85f8888c8a6e9aec6dc378293ab6d91d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f220095760405b89008d366ad8b0b95b7286dd1cb28cf4338b9982a4ea00eb91"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d0e1bd20cfe210e96847b8c7ab7ce9902297006eb71f680abb64eb2ee6a7c2d2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "78e819bfe0d7fd52fb17ebaf2423956e5aa36d16cf6b3da95c9afa1599850bfa"
    sha256 cellar: :any_skip_relocation, sonoma:         "d1167a0333be9a66a805c64e182dd7c261a8b517727b6890d691b565d9e656f9"
    sha256 cellar: :any_skip_relocation, ventura:        "b8b898bda26fd31224d9e1cec9ed1de46c3c276f68f7f460e85ca79e2e61f96d"
    sha256 cellar: :any_skip_relocation, monterey:       "b71cd06b9c66f86a38c33e0445fc23d6af3e89cb4dc1f7459313031f345e28b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a8dffc474f6cf88a85500d95c75a859740488691596b9d26592f1e19d55457cf"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
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