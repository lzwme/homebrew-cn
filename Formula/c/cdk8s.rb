class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.207.74.tgz"
  sha256 "ae10dd1d262ad9941ada7eab848215a0c17057800bcae17d17b58c044a74615a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b9f2455a9f233b48eaf19b7ae6ea061256af64c1def2057fafd0f805c3a3b366"
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