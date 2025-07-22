class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.200.137.tgz"
  sha256 "bef3eaec7adc5059d04c67872579a50639e06afa654b43d0541aeadaf80b7ab8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dd991b0c05ad2f04c573bc336d33860784e60786d88274fb79adfa3633aeeed1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dd991b0c05ad2f04c573bc336d33860784e60786d88274fb79adfa3633aeeed1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dd991b0c05ad2f04c573bc336d33860784e60786d88274fb79adfa3633aeeed1"
    sha256 cellar: :any_skip_relocation, sonoma:        "fada3ec02f7f7a6f8b970cf2920799fe3e7f4c8c98d920cb19022258d61d387b"
    sha256 cellar: :any_skip_relocation, ventura:       "fada3ec02f7f7a6f8b970cf2920799fe3e7f4c8c98d920cb19022258d61d387b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dd991b0c05ad2f04c573bc336d33860784e60786d88274fb79adfa3633aeeed1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd991b0c05ad2f04c573bc336d33860784e60786d88274fb79adfa3633aeeed1"
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