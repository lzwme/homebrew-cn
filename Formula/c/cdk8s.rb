class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.200.97.tgz"
  sha256 "5f6e6002d1cc3f5f271d9e06f6b4bc62f0e57da8426fe2917a1161f6c89ad8ea"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fc3d1758946cc899ddba3d77f97361ca777b471a368f7f634c99876be5f4d88e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fc3d1758946cc899ddba3d77f97361ca777b471a368f7f634c99876be5f4d88e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fc3d1758946cc899ddba3d77f97361ca777b471a368f7f634c99876be5f4d88e"
    sha256 cellar: :any_skip_relocation, sonoma:        "41436367fb562bf4e0b8b8b4ad31c2c8d62b151ab0bda12c1a33fd55fdb4e78c"
    sha256 cellar: :any_skip_relocation, ventura:       "41436367fb562bf4e0b8b8b4ad31c2c8d62b151ab0bda12c1a33fd55fdb4e78c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fc3d1758946cc899ddba3d77f97361ca777b471a368f7f634c99876be5f4d88e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fc3d1758946cc899ddba3d77f97361ca777b471a368f7f634c99876be5f4d88e"
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