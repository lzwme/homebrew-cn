require "language/node"

class SnykCli < Formula
  desc "Scans and monitors projects for security vulnerabilities"
  homepage "https://snyk.io"
  url "https://registry.npmjs.org/snyk/-/snyk-1.1253.0.tgz"
  sha256 "971a7612539d24699884ca4dc21bf358d04a2cb588490371203aae9defe7c461"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "974a83b533474ae64f766d2bdd2003d4abdc294dad0e943dd9eb0d5f2e8093a6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7dbca79628e774aab2d73c0c2a1a44ec507064c628efedfc8d81091adc40cbca"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d4762a84c3154d3e539db6d516a884faf8ab27371892ee56e8230a1881d5c804"
    sha256 cellar: :any_skip_relocation, sonoma:         "60ed37ac58fc0597464750e6e430384fab1193f203bd5e06007a7cf0b5851a19"
    sha256 cellar: :any_skip_relocation, ventura:        "9e39ab6adcadc005ef04238c62472f6a414974744cf9417709118f37e941795e"
    sha256 cellar: :any_skip_relocation, monterey:       "77e3e24dd84bc737e59c51b6d7727580c38798d4af5e7a485b538ac9db173184"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c3cdaf2187447630f288a2a19ec2dd254130cc87c7a5028b1b69a74a440d8c1"
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