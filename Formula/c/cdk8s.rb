class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.200.127.tgz"
  sha256 "09a1b826f9e3d2e639eca16230e90aa8770d582b17059377fff5f688b123f100"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6758429bd22b5185ea1c58c42c83748abc62e303c837fdec58b2ce18787bda95"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6758429bd22b5185ea1c58c42c83748abc62e303c837fdec58b2ce18787bda95"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6758429bd22b5185ea1c58c42c83748abc62e303c837fdec58b2ce18787bda95"
    sha256 cellar: :any_skip_relocation, sonoma:        "970a2ef7eacefc2e0458ab4f650f4ca099c47d5b274153e8b05823cffcd6347e"
    sha256 cellar: :any_skip_relocation, ventura:       "970a2ef7eacefc2e0458ab4f650f4ca099c47d5b274153e8b05823cffcd6347e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6758429bd22b5185ea1c58c42c83748abc62e303c837fdec58b2ce18787bda95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6758429bd22b5185ea1c58c42c83748abc62e303c837fdec58b2ce18787bda95"
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