class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.200.104.tgz"
  sha256 "1d5233238d09bff6b54432afe3bf654f31dae3c031d9f80b31ae0ffb4375ca85"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e6d016c2814eafca73eb541352e0fd6a4f750ce65b4322d59c2c9e16e4d7d41a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e6d016c2814eafca73eb541352e0fd6a4f750ce65b4322d59c2c9e16e4d7d41a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e6d016c2814eafca73eb541352e0fd6a4f750ce65b4322d59c2c9e16e4d7d41a"
    sha256 cellar: :any_skip_relocation, sonoma:        "def6b962345a08e7a5150575489830117e9c88f7c82deb8fba4dacd004462769"
    sha256 cellar: :any_skip_relocation, ventura:       "def6b962345a08e7a5150575489830117e9c88f7c82deb8fba4dacd004462769"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e6d016c2814eafca73eb541352e0fd6a4f750ce65b4322d59c2c9e16e4d7d41a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e6d016c2814eafca73eb541352e0fd6a4f750ce65b4322d59c2c9e16e4d7d41a"
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