class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.223.tgz"
  sha256 "6093f6a97c36cb021ce584f5a9488857e6deed4f81a05c298b1fbc965cfc8d0d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8f38a9891896145b564c6cd5b16362d4540cc53dfe94d3b9252403c1347b00b1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8f38a9891896145b564c6cd5b16362d4540cc53dfe94d3b9252403c1347b00b1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8f38a9891896145b564c6cd5b16362d4540cc53dfe94d3b9252403c1347b00b1"
    sha256 cellar: :any_skip_relocation, sonoma:        "20b6df3c5de599a638ab1875ee41885e9c608bbc616b73f624311704944fe244"
    sha256 cellar: :any_skip_relocation, ventura:       "20b6df3c5de599a638ab1875ee41885e9c608bbc616b73f624311704944fe244"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8f38a9891896145b564c6cd5b16362d4540cc53dfe94d3b9252403c1347b00b1"
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