require "language/node"

class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.30.0.tgz"
  sha256 "ac4537f80c806ca18950e3de9d3b0d8ff7eb0411aeb708fc8a20db4e17ad4703"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d9772ca866c7aa14b3d5905e51373d30ad6e8bc32e50bfbeedbce596fefa0baa"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d9772ca866c7aa14b3d5905e51373d30ad6e8bc32e50bfbeedbce596fefa0baa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d9772ca866c7aa14b3d5905e51373d30ad6e8bc32e50bfbeedbce596fefa0baa"
    sha256 cellar: :any_skip_relocation, sonoma:         "d9772ca866c7aa14b3d5905e51373d30ad6e8bc32e50bfbeedbce596fefa0baa"
    sha256 cellar: :any_skip_relocation, ventura:        "d9772ca866c7aa14b3d5905e51373d30ad6e8bc32e50bfbeedbce596fefa0baa"
    sha256 cellar: :any_skip_relocation, monterey:       "d9772ca866c7aa14b3d5905e51373d30ad6e8bc32e50bfbeedbce596fefa0baa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5ad170131ce3706d651097e3b742cbf0449b04d9f2a6ad64a6d68aff78f2a1a5"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/fern init 2>&1", 1)
    assert_match "Login required", output

    assert_match version.to_s, shell_output("#{bin}/fern --version")
  end
end