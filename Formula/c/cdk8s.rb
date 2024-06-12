require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.143.tgz"
  sha256 "468bc491af425cb4644b50445923f9ee5c196f800da5fd885e314b770f59d466"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0f46e9e1e01b935cb678f1a3757a31b7c054b0e6f5edd5379501b8dc161b294e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0f46e9e1e01b935cb678f1a3757a31b7c054b0e6f5edd5379501b8dc161b294e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0f46e9e1e01b935cb678f1a3757a31b7c054b0e6f5edd5379501b8dc161b294e"
    sha256 cellar: :any_skip_relocation, sonoma:         "02fb77bd744e3d88c6d442cbe74cb2a9cf8986732553d1374539c9712f371975"
    sha256 cellar: :any_skip_relocation, ventura:        "02fb77bd744e3d88c6d442cbe74cb2a9cf8986732553d1374539c9712f371975"
    sha256 cellar: :any_skip_relocation, monterey:       "02fb77bd744e3d88c6d442cbe74cb2a9cf8986732553d1374539c9712f371975"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6009ce75cf6774fb57feea73c52148f9eccb374822ca359092b87808dc98709d"
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