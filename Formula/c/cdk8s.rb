require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.121.tgz"
  sha256 "a545c81e4d7a65f3a86fb2b6966aab7d8f9c0678c5a8686db10e183d0be50324"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d629a6243c987cba859670b3bd88791c4f6daedb438595e4c5f98216ef498a65"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e9f498a331671f494608e345713b49d8bbac06c532cc0f9c371691ec000bb700"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "be126275446e4aec509a2f868495209c9c274c0f472e38de67606a33d42737a8"
    sha256 cellar: :any_skip_relocation, sonoma:         "d52d047d5f1e88ef29995583ec6833de79f621290894affe9d40687b65b16c25"
    sha256 cellar: :any_skip_relocation, ventura:        "520e417cbbea85db17b5f11f31514bee76b057bcd0b0c8bc80105fd8adc369b8"
    sha256 cellar: :any_skip_relocation, monterey:       "51770829711ee11eaddd650ea980d947104362138465f0e4f980f74996117795"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eac42d2f9cfa8ac1c49953cf1ed6e4b610ce5a22aa24e5c122405626bf80eb90"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/cdk8s init python-app 2>&1", 1)
    assert_match "Initializing a project from the python-app template", output
  end
end