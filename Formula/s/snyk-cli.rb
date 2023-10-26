require "language/node"

class SnykCli < Formula
  desc "Scans and monitors projects for security vulnerabilities"
  homepage "https://snyk.io"
  url "https://registry.npmjs.org/snyk/-/snyk-1.1237.0.tgz"
  sha256 "8eea3a603e5a220d89d37e87c020cebb456ee7848cecc62a8bdeba4ebb2256f9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "092cd5559e9a9ccc0a66798d8b663cc556ae9e17b926da48ec9127185449b33b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "389f468f790e2ee2f17632f25f58f0dce73ed7ea3528d6e96d3a7aa76385ca79"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "41df6fcead42edd866af94ea5445a206465e9015835972e754f2221f4f70a524"
    sha256 cellar: :any_skip_relocation, sonoma:         "2949ac13bee71f34f52493f860f9016a9f14bde9cda9ccccced386e0d3bec845"
    sha256 cellar: :any_skip_relocation, ventura:        "39029d8f2f53d002c6e90eb92354e4df82ba28cecd1ffb2009f71713a5487309"
    sha256 cellar: :any_skip_relocation, monterey:       "e6caf7027467a660246ab1d8cee42d06f529009abe7b2207ae6e987a2b26ab2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9fab200f6af3ee85c677cfc52a5c7b612dbcf01fe621eca14f02b49240937452"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/snyk version")

    output = shell_output("#{bin}/snyk auth homebrew", 2)
    assert_match "Authentication failed. Please check the API token on https://snyk.io", output
  end
end