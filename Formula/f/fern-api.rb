require "language/node"

class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.35.0.tgz"
  sha256 "06c42aea39802a411c535fa6a9b86f11ec33f9d9d070e59e2b205c037c968367"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0a9f3c9292247e506b9ca1b79cd8a66117dfe57c37b3355dd3d852880eb3595b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0a9f3c9292247e506b9ca1b79cd8a66117dfe57c37b3355dd3d852880eb3595b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0a9f3c9292247e506b9ca1b79cd8a66117dfe57c37b3355dd3d852880eb3595b"
    sha256 cellar: :any_skip_relocation, sonoma:         "0a9f3c9292247e506b9ca1b79cd8a66117dfe57c37b3355dd3d852880eb3595b"
    sha256 cellar: :any_skip_relocation, ventura:        "0a9f3c9292247e506b9ca1b79cd8a66117dfe57c37b3355dd3d852880eb3595b"
    sha256 cellar: :any_skip_relocation, monterey:       "0a9f3c9292247e506b9ca1b79cd8a66117dfe57c37b3355dd3d852880eb3595b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c061420a608d130a0e03202e093f4815db0eb83887013919a42da1f843cd05da"
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