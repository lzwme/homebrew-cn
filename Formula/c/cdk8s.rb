class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.216.tgz"
  sha256 "4aa2ee22272cbe1e7175cb83168fadcef875b2bfdaa057e1f8dd7a18a81bda08"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "cadc9c29faceed38e14411e797e97f367645984965c31b3814cceb746cfaf4f2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cadc9c29faceed38e14411e797e97f367645984965c31b3814cceb746cfaf4f2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cadc9c29faceed38e14411e797e97f367645984965c31b3814cceb746cfaf4f2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cadc9c29faceed38e14411e797e97f367645984965c31b3814cceb746cfaf4f2"
    sha256 cellar: :any_skip_relocation, sonoma:         "17f1fb10f03f3208157235f48b507e9e5454e2bfbde952cf08b4bd26779a4dce"
    sha256 cellar: :any_skip_relocation, ventura:        "17f1fb10f03f3208157235f48b507e9e5454e2bfbde952cf08b4bd26779a4dce"
    sha256 cellar: :any_skip_relocation, monterey:       "17f1fb10f03f3208157235f48b507e9e5454e2bfbde952cf08b4bd26779a4dce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cadc9c29faceed38e14411e797e97f367645984965c31b3814cceb746cfaf4f2"
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