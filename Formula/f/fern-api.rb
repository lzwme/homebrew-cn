require "language/node"

class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.31.6.tgz"
  sha256 "238fd8af3142d2851085034c4346d11f8fa56411f2edf49b77abed26e5bbf26e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a42cd9a2798258aee3a530d2668373836d5e07486d132b6c5a8b7a7b82fb3e57"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a42cd9a2798258aee3a530d2668373836d5e07486d132b6c5a8b7a7b82fb3e57"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a42cd9a2798258aee3a530d2668373836d5e07486d132b6c5a8b7a7b82fb3e57"
    sha256 cellar: :any_skip_relocation, sonoma:         "a42cd9a2798258aee3a530d2668373836d5e07486d132b6c5a8b7a7b82fb3e57"
    sha256 cellar: :any_skip_relocation, ventura:        "a42cd9a2798258aee3a530d2668373836d5e07486d132b6c5a8b7a7b82fb3e57"
    sha256 cellar: :any_skip_relocation, monterey:       "a42cd9a2798258aee3a530d2668373836d5e07486d132b6c5a8b7a7b82fb3e57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eadc2dd565f26b33925602ccd9698ecef834e86b3846a974fdf7fccde7e7ea6f"
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