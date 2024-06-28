require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.157.tgz"
  sha256 "9439f3bfe63535bd10ea58fb0aa166e37bb00b2b10163eb9b5b009a4eeab4ff2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3c7acbc253d6e46e0a07a558ffffd648726a28b1baeeeea14332973e162c6b0c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3c7acbc253d6e46e0a07a558ffffd648726a28b1baeeeea14332973e162c6b0c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3c7acbc253d6e46e0a07a558ffffd648726a28b1baeeeea14332973e162c6b0c"
    sha256 cellar: :any_skip_relocation, sonoma:         "d249e93b79cc30127154335d9ab6e46a7aa3b6b1fcbfa221a45ef466cef339f4"
    sha256 cellar: :any_skip_relocation, ventura:        "d249e93b79cc30127154335d9ab6e46a7aa3b6b1fcbfa221a45ef466cef339f4"
    sha256 cellar: :any_skip_relocation, monterey:       "d249e93b79cc30127154335d9ab6e46a7aa3b6b1fcbfa221a45ef466cef339f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e72dc4f65717919823436e49c2e4a633ef9b181f25bc5de54a3638a1ae83ac75"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/cdk8s init python-app 2>&1", 1)
    assert_match "Initializing a project from the python-app template", output
  end
end