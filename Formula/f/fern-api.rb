require "language/node"

class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.31.21.tgz"
  sha256 "7072af4d983902344e435614eaa5e952da9c988322cad4b3977bb66162b6c46b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c305266515b2f3bae6456121a023fdaed4147e8b7657eb29f538558f9241f6ea"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c305266515b2f3bae6456121a023fdaed4147e8b7657eb29f538558f9241f6ea"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c305266515b2f3bae6456121a023fdaed4147e8b7657eb29f538558f9241f6ea"
    sha256 cellar: :any_skip_relocation, sonoma:         "b4a8ccd6bbaedd5421b0f3be25792b395adc901ff8a0326eddc2fcc4b73f7ad9"
    sha256 cellar: :any_skip_relocation, ventura:        "b4a8ccd6bbaedd5421b0f3be25792b395adc901ff8a0326eddc2fcc4b73f7ad9"
    sha256 cellar: :any_skip_relocation, monterey:       "c305266515b2f3bae6456121a023fdaed4147e8b7657eb29f538558f9241f6ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "05887f30140c73d120476274ce2cc015ff10775318fd69cefffcf86adc0d2087"
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