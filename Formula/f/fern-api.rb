require "language/node"

class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.31.24.tgz"
  sha256 "8ed0f431647e45c2c0cf998b535ef6d48b0d7b1e539ab207ca4655d74e00d6d9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2792a3e51c04661b68a2aabe8ae005dc8b98a98bc61205158dddcb7dafe5d70e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2792a3e51c04661b68a2aabe8ae005dc8b98a98bc61205158dddcb7dafe5d70e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2792a3e51c04661b68a2aabe8ae005dc8b98a98bc61205158dddcb7dafe5d70e"
    sha256 cellar: :any_skip_relocation, sonoma:         "2792a3e51c04661b68a2aabe8ae005dc8b98a98bc61205158dddcb7dafe5d70e"
    sha256 cellar: :any_skip_relocation, ventura:        "2792a3e51c04661b68a2aabe8ae005dc8b98a98bc61205158dddcb7dafe5d70e"
    sha256 cellar: :any_skip_relocation, monterey:       "2792a3e51c04661b68a2aabe8ae005dc8b98a98bc61205158dddcb7dafe5d70e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "181fe890816112a1524737883d89030e0ac6b23ffe1db75e9d2e9674b4a50266"
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