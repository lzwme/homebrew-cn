require "language/node"

class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.33.3.tgz"
  sha256 "73aff433df3db2bb9769575908b82c9d326b78ab8fc5e59b4fb18fd898bf8916"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ae96dcaab4325e669c49061fff6be9e640c53a190cbc83999a993a13a62c7915"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ae96dcaab4325e669c49061fff6be9e640c53a190cbc83999a993a13a62c7915"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ae96dcaab4325e669c49061fff6be9e640c53a190cbc83999a993a13a62c7915"
    sha256 cellar: :any_skip_relocation, sonoma:         "ae96dcaab4325e669c49061fff6be9e640c53a190cbc83999a993a13a62c7915"
    sha256 cellar: :any_skip_relocation, ventura:        "ae96dcaab4325e669c49061fff6be9e640c53a190cbc83999a993a13a62c7915"
    sha256 cellar: :any_skip_relocation, monterey:       "ae96dcaab4325e669c49061fff6be9e640c53a190cbc83999a993a13a62c7915"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "80c49ba637aa0d3847ab4e701a97cdda138d65414662394f7fcce972a6dd9c05"
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