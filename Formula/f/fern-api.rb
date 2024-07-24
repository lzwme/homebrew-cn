require "language/node"

class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.33.5.tgz"
  sha256 "e5ca5185aa63ededa44e5a5d1ecbcf45449e380235fdd759b482cddf37d2e072"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a05f4e96736895339e25c945f24c2a8ae01a7167a3f2221cafa38da7f2be04e1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a05f4e96736895339e25c945f24c2a8ae01a7167a3f2221cafa38da7f2be04e1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a05f4e96736895339e25c945f24c2a8ae01a7167a3f2221cafa38da7f2be04e1"
    sha256 cellar: :any_skip_relocation, sonoma:         "d6961a200cddf4929726fbc75fa305ea8256a911c5068f6ca0ca081a8365ed6b"
    sha256 cellar: :any_skip_relocation, ventura:        "75623441bae9997ee03722343173a0e734581d7bf57512738557037b29abdc3e"
    sha256 cellar: :any_skip_relocation, monterey:       "a05f4e96736895339e25c945f24c2a8ae01a7167a3f2221cafa38da7f2be04e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7e23890e9c3e766ebfdb5d5e694d71ef9d66924a77ed123f51cdd4726fd9270b"
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