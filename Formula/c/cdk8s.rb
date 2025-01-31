class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https:cdk8s.io"
  url "https:registry.npmjs.orgcdk8s-cli-cdk8s-cli-2.198.309.tgz"
  sha256 "f0f40be5f0784d36be7c7f9faa543726e9f641edf2876a2973919950a89f7f5a"
  license "Apache-2.0"
  head "https:github.comcdk8s-teamcdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4d01b6ee42aa3010679c4a6139af10db54b171f5ac6828384c59a183f0cd9d60"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4d01b6ee42aa3010679c4a6139af10db54b171f5ac6828384c59a183f0cd9d60"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4d01b6ee42aa3010679c4a6139af10db54b171f5ac6828384c59a183f0cd9d60"
    sha256 cellar: :any_skip_relocation, sonoma:        "687f1470d32269d62eb8995092c7ad74c936f39fc4a3536c81617f1f4e02841d"
    sha256 cellar: :any_skip_relocation, ventura:       "687f1470d32269d62eb8995092c7ad74c936f39fc4a3536c81617f1f4e02841d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d01b6ee42aa3010679c4a6139af10db54b171f5ac6828384c59a183f0cd9d60"
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