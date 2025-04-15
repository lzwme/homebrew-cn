class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https:cdk8s.io"
  url "https:registry.npmjs.orgcdk8s-cli-cdk8s-cli-2.200.42.tgz"
  sha256 "e5deba4923ee98eafd62eca7dd3d7c4f27e9a774cbc635b525afeaf3d236dd77"
  license "Apache-2.0"
  head "https:github.comcdk8s-teamcdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d5f657928e1548ecc1039d85111464681e53758ce07dab98034d9adb08388df9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d5f657928e1548ecc1039d85111464681e53758ce07dab98034d9adb08388df9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d5f657928e1548ecc1039d85111464681e53758ce07dab98034d9adb08388df9"
    sha256 cellar: :any_skip_relocation, sonoma:        "154e1e694003a8af7958cd8efff6eddcfd9cff0a975067d94f312d413b1f1a34"
    sha256 cellar: :any_skip_relocation, ventura:       "154e1e694003a8af7958cd8efff6eddcfd9cff0a975067d94f312d413b1f1a34"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d5f657928e1548ecc1039d85111464681e53758ce07dab98034d9adb08388df9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d5f657928e1548ecc1039d85111464681e53758ce07dab98034d9adb08388df9"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    output = shell_output("#{bin}cdk8s init python-app 2>&1", 1)
    assert_match "Initializing a project from the python-app template", output
  end
end