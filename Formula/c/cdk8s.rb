class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.200.76.tgz"
  sha256 "20930a300c7a3e5713ce5d4553b24ad296757acd75a5c6ffc6f8e9a3ca07cf3f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0fb1779912d56a71a2f2450b4bebbcd42c32d76a444710faf9b10f83742d3162"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0fb1779912d56a71a2f2450b4bebbcd42c32d76a444710faf9b10f83742d3162"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0fb1779912d56a71a2f2450b4bebbcd42c32d76a444710faf9b10f83742d3162"
    sha256 cellar: :any_skip_relocation, sonoma:        "465cd79ad11d9930440e6ccae0acbc912b711957fa6573f23bd4dd0401bbbb77"
    sha256 cellar: :any_skip_relocation, ventura:       "465cd79ad11d9930440e6ccae0acbc912b711957fa6573f23bd4dd0401bbbb77"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0fb1779912d56a71a2f2450b4bebbcd42c32d76a444710faf9b10f83742d3162"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0fb1779912d56a71a2f2450b4bebbcd42c32d76a444710faf9b10f83742d3162"
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