class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.200.148.tgz"
  sha256 "5a5f4c971ccd6830a4db092f8a73b7149ff4039c6687ba944dc9c3b46d91c574"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "72b2c6ace5d1f15f6f4a958da166c97e074ab9ed497e7907cfdfab28cf7c30a7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "72b2c6ace5d1f15f6f4a958da166c97e074ab9ed497e7907cfdfab28cf7c30a7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "72b2c6ace5d1f15f6f4a958da166c97e074ab9ed497e7907cfdfab28cf7c30a7"
    sha256 cellar: :any_skip_relocation, sonoma:        "9aa595faba2eb48dfeb4b1741cdd5f0b663820a68739189eff1934f71c1f2985"
    sha256 cellar: :any_skip_relocation, ventura:       "9aa595faba2eb48dfeb4b1741cdd5f0b663820a68739189eff1934f71c1f2985"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "72b2c6ace5d1f15f6f4a958da166c97e074ab9ed497e7907cfdfab28cf7c30a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "72b2c6ace5d1f15f6f4a958da166c97e074ab9ed497e7907cfdfab28cf7c30a7"
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