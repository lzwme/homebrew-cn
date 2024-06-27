require "language/node"

class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.31.2.tgz"
  sha256 "6e9c9fd3762052e2adec4b6659ee5b7d962b0ccffa3e224881f9773f7590466e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fe7717557cfacd35b7fd4df59d082ce0e2f2e3c3fd33b1ccc2f2056d63561d4e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fe7717557cfacd35b7fd4df59d082ce0e2f2e3c3fd33b1ccc2f2056d63561d4e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fe7717557cfacd35b7fd4df59d082ce0e2f2e3c3fd33b1ccc2f2056d63561d4e"
    sha256 cellar: :any_skip_relocation, sonoma:         "fe7717557cfacd35b7fd4df59d082ce0e2f2e3c3fd33b1ccc2f2056d63561d4e"
    sha256 cellar: :any_skip_relocation, ventura:        "fe7717557cfacd35b7fd4df59d082ce0e2f2e3c3fd33b1ccc2f2056d63561d4e"
    sha256 cellar: :any_skip_relocation, monterey:       "fe7717557cfacd35b7fd4df59d082ce0e2f2e3c3fd33b1ccc2f2056d63561d4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff51b71a175d7ed97fe2a5f30193740f635dd37361a69c6e275a97c4193cfd7b"
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