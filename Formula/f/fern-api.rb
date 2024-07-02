require "language/node"

class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.31.9.tgz"
  sha256 "53e8c9ec26c7e1d6cb703ded3e4477c1586e9c324d024ed55375ff80b161bcae"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cf17925a775cfff7ea83377a74d53df76cdf36c109f7069e276bf297f967636f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cf17925a775cfff7ea83377a74d53df76cdf36c109f7069e276bf297f967636f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cf17925a775cfff7ea83377a74d53df76cdf36c109f7069e276bf297f967636f"
    sha256 cellar: :any_skip_relocation, sonoma:         "cf17925a775cfff7ea83377a74d53df76cdf36c109f7069e276bf297f967636f"
    sha256 cellar: :any_skip_relocation, ventura:        "cf17925a775cfff7ea83377a74d53df76cdf36c109f7069e276bf297f967636f"
    sha256 cellar: :any_skip_relocation, monterey:       "cf17925a775cfff7ea83377a74d53df76cdf36c109f7069e276bf297f967636f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c5aeb65f9bade646f0e775dcb070f14800bcc1edfa7f2c572d09cb905e593eb"
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