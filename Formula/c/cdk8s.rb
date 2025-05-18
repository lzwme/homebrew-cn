class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.200.73.tgz"
  sha256 "da827ead58c79402457d9c140122964a82bd364c2d82af3d959f9e60ee9d2578"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4fa7200450b80bc44fe33a450ee7efc32e5abc73315bad672964d363c4d5aa3e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4fa7200450b80bc44fe33a450ee7efc32e5abc73315bad672964d363c4d5aa3e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4fa7200450b80bc44fe33a450ee7efc32e5abc73315bad672964d363c4d5aa3e"
    sha256 cellar: :any_skip_relocation, sonoma:        "f9c5ac4c14bdd7825a4be1e87402f365c76140a220a536640d4ecd0cbde90038"
    sha256 cellar: :any_skip_relocation, ventura:       "f9c5ac4c14bdd7825a4be1e87402f365c76140a220a536640d4ecd0cbde90038"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4fa7200450b80bc44fe33a450ee7efc32e5abc73315bad672964d363c4d5aa3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4fa7200450b80bc44fe33a450ee7efc32e5abc73315bad672964d363c4d5aa3e"
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