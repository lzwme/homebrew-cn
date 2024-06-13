require "language/node"

class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.30.4.tgz"
  sha256 "17a7e3a62c670c24aed5aa4472f0c8416fd36a90e04c91789a27f71ffe06f0de"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f4aea4680e690abfe5a580ef16aede3237efbe531a6211df7ddea8e683b6556d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f4aea4680e690abfe5a580ef16aede3237efbe531a6211df7ddea8e683b6556d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f4aea4680e690abfe5a580ef16aede3237efbe531a6211df7ddea8e683b6556d"
    sha256 cellar: :any_skip_relocation, sonoma:         "f4aea4680e690abfe5a580ef16aede3237efbe531a6211df7ddea8e683b6556d"
    sha256 cellar: :any_skip_relocation, ventura:        "f4aea4680e690abfe5a580ef16aede3237efbe531a6211df7ddea8e683b6556d"
    sha256 cellar: :any_skip_relocation, monterey:       "f4aea4680e690abfe5a580ef16aede3237efbe531a6211df7ddea8e683b6556d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "26b19359dfaecbdcd08066b18b7e27b3f79943cc751dc0db20359980377a5e2a"
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