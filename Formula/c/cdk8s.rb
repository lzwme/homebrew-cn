class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.221.tgz"
  sha256 "3bb4d586d52fab020808021e15b5ea9e348fba0fdb24611e3744e37967a05aea"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "68d4bf1955e87b4340e62ea358ddc8e40536e67f25da127f07bd28e1ba40795f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "68d4bf1955e87b4340e62ea358ddc8e40536e67f25da127f07bd28e1ba40795f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "68d4bf1955e87b4340e62ea358ddc8e40536e67f25da127f07bd28e1ba40795f"
    sha256 cellar: :any_skip_relocation, sonoma:        "1e2f560c93070357c6c5b04ac5a4ec6bd1ff7b64b756821e5ba9fe7755a72163"
    sha256 cellar: :any_skip_relocation, ventura:       "1e2f560c93070357c6c5b04ac5a4ec6bd1ff7b64b756821e5ba9fe7755a72163"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "68d4bf1955e87b4340e62ea358ddc8e40536e67f25da127f07bd28e1ba40795f"
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