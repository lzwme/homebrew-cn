class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https:cdk8s.io"
  url "https:registry.npmjs.orgcdk8s-cli-cdk8s-cli-2.198.283.tgz"
  sha256 "3183a53fd6687fb0c84a1f7c3f0ca0d5b9f5373eff567a0fa753cf41b2930b6c"
  license "Apache-2.0"
  head "https:github.comcdk8s-teamcdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b2632057b391b7b2eccd105b8d4f203da25eba13fb0e01c03f41aece48ca7c2b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b2632057b391b7b2eccd105b8d4f203da25eba13fb0e01c03f41aece48ca7c2b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b2632057b391b7b2eccd105b8d4f203da25eba13fb0e01c03f41aece48ca7c2b"
    sha256 cellar: :any_skip_relocation, sonoma:        "43ea176905b9a1cd891ade447ff85d6b603a64ddf794f194f7e8773a12279a4e"
    sha256 cellar: :any_skip_relocation, ventura:       "43ea176905b9a1cd891ade447ff85d6b603a64ddf794f194f7e8773a12279a4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b2632057b391b7b2eccd105b8d4f203da25eba13fb0e01c03f41aece48ca7c2b"
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