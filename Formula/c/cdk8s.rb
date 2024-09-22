class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.224.tgz"
  sha256 "e93a3867583af8d4a05fb4fc03dd164af59c82eb6da1fe7b7b29661731b50bf8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "31089c499e1c64bc2fdf47fc93facf66df83cb37dd47a63fc8ce1b9e745df34c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "31089c499e1c64bc2fdf47fc93facf66df83cb37dd47a63fc8ce1b9e745df34c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "31089c499e1c64bc2fdf47fc93facf66df83cb37dd47a63fc8ce1b9e745df34c"
    sha256 cellar: :any_skip_relocation, sonoma:        "a339eed502f4fdd7f8e77ef0285d3f2e0206049a5382a2a448f0af29a3bb8181"
    sha256 cellar: :any_skip_relocation, ventura:       "a339eed502f4fdd7f8e77ef0285d3f2e0206049a5382a2a448f0af29a3bb8181"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "31089c499e1c64bc2fdf47fc93facf66df83cb37dd47a63fc8ce1b9e745df34c"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/cdk8s init python-app 2>&1", 1)
    assert_match "Initializing a project from the python-app template", output
  end
end