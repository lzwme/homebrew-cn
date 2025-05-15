class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.200.71.tgz"
  sha256 "f2413ea1ed69c2a4b972a80841b49b1b7e69beb088e14133c2c220262762aa08"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d4ac3ae2f04fe226d9bef91cd949b422d7d259ec5a470bee20c7d28796d2963e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d4ac3ae2f04fe226d9bef91cd949b422d7d259ec5a470bee20c7d28796d2963e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d4ac3ae2f04fe226d9bef91cd949b422d7d259ec5a470bee20c7d28796d2963e"
    sha256 cellar: :any_skip_relocation, sonoma:        "f4e37b24beb20ab43f1c6677a2d650a0877cc6ffaa6677a6a045a428f7d66a6d"
    sha256 cellar: :any_skip_relocation, ventura:       "f4e37b24beb20ab43f1c6677a2d650a0877cc6ffaa6677a6a045a428f7d66a6d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d4ac3ae2f04fe226d9bef91cd949b422d7d259ec5a470bee20c7d28796d2963e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d4ac3ae2f04fe226d9bef91cd949b422d7d259ec5a470bee20c7d28796d2963e"
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