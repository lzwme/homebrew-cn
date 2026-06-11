class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.207.19.tgz"
  sha256 "02aca3d8d22c99ab16a293e1301f906d877a6993d851f07ecb067b4f37dea2cc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0fba5b14c3bf27940805194d9fa6e67386f6d1c89b9b54482be51d78a17d1d04"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    output = shell_output("#{bin}/cdk8s init python-app 2>&1", 1)
    assert_match "Initializing a project from the python-app template", output
  end
end