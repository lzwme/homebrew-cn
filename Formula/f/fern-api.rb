require "language/node"

class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.30.10.tgz"
  sha256 "f609376b7c29becbc5e1b6f3eecc6ebf65d69aaa012bc33ce43c7ba3cc40865b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ff51ade80a358ea443811dbf28aaa138071a9f10b43efb0453130d5ced1e9637"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ff51ade80a358ea443811dbf28aaa138071a9f10b43efb0453130d5ced1e9637"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ff51ade80a358ea443811dbf28aaa138071a9f10b43efb0453130d5ced1e9637"
    sha256 cellar: :any_skip_relocation, sonoma:         "ff51ade80a358ea443811dbf28aaa138071a9f10b43efb0453130d5ced1e9637"
    sha256 cellar: :any_skip_relocation, ventura:        "ff51ade80a358ea443811dbf28aaa138071a9f10b43efb0453130d5ced1e9637"
    sha256 cellar: :any_skip_relocation, monterey:       "ff51ade80a358ea443811dbf28aaa138071a9f10b43efb0453130d5ced1e9637"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "45d3f4cc855d2dd898029e1db9b2c11271eef86d21cfb9b404659b3fe6fbe0d8"
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