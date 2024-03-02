require "languagenode"

class Seam < Formula
  desc "This utility lets you control Seam resources"
  homepage "https:github.comseamapiseam-cli"
  url "https:registry.npmjs.orgseam-cli-seam-cli-0.0.50.tgz"
  sha256 "5f4997d8135601218464ae0e8eca4d6f5f875003719775ed273dc32076f34ae9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d81b23386c7905eaa0d595a13a15df9486f5ce594246b3fc9b5339d8ff39becd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d81b23386c7905eaa0d595a13a15df9486f5ce594246b3fc9b5339d8ff39becd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d81b23386c7905eaa0d595a13a15df9486f5ce594246b3fc9b5339d8ff39becd"
    sha256 cellar: :any_skip_relocation, sonoma:         "15c6bf89f2e301ede5d8a749b7bdeefea352c0ea39c314707b4d30f2d00badc0"
    sha256 cellar: :any_skip_relocation, ventura:        "15c6bf89f2e301ede5d8a749b7bdeefea352c0ea39c314707b4d30f2d00badc0"
    sha256 cellar: :any_skip_relocation, monterey:       "15c6bf89f2e301ede5d8a749b7bdeefea352c0ea39c314707b4d30f2d00badc0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d81b23386c7905eaa0d595a13a15df9486f5ce594246b3fc9b5339d8ff39becd"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    system bin"seam", "config", "set", "fake-server"
    output = shell_output("#{bin}seam health get_health")
    assert_match "I’m one with the Force. The Force is with me.", output
  end
end