class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.103.6.tgz"
  sha256 "b9554db026afb9b50832228407ab8e2107b300f204eee8a6bf424a6afb0009cc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "047e98ed8b09f53de763718398f2aee1ff23bb2f38c581062d3c51ac38a2ec0a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d2b1c0b3cd7448b50b292951bc6b870714b54cdecad2919b99f9e5b03ea97287"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "116295de89b7839fe28d5db5d4f30fde7e6f740ef6ed9fa180b1288e5a0ec19b"
    sha256 cellar: :any_skip_relocation, sonoma:        "8591dad1690feb4839208f2a8aa68841d077737c3a906e29f7ff8b5401839ed0"
    sha256 cellar: :any_skip_relocation, ventura:       "6d0e2745261a2ec2ad9f266ee7e6c41eca480c50f683ffd5020d3931d44a62e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6cea7e83f7c964a578410e0519a5314e5946d47d249387ddb67d8aa8a94cf484"
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