require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.36.0.tgz"
  sha256 "b97d6a42a7cd15fffea0faa577c0b58267b322d5bd1a01b1c4dd4eaed67319d1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "41de71f91b5dc932a044809ed8bee7348aa686b627c6dd83c5828657a04b54ad"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "41de71f91b5dc932a044809ed8bee7348aa686b627c6dd83c5828657a04b54ad"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "41de71f91b5dc932a044809ed8bee7348aa686b627c6dd83c5828657a04b54ad"
    sha256 cellar: :any_skip_relocation, ventura:        "0f42e193a7c104f84596b68f283b15c59d5d05707947d8b145dfed34ddcdd9dc"
    sha256 cellar: :any_skip_relocation, monterey:       "0f42e193a7c104f84596b68f283b15c59d5d05707947d8b145dfed34ddcdd9dc"
    sha256 cellar: :any_skip_relocation, big_sur:        "0f42e193a7c104f84596b68f283b15c59d5d05707947d8b145dfed34ddcdd9dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "41de71f91b5dc932a044809ed8bee7348aa686b627c6dd83c5828657a04b54ad"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "Cannot initialize a project in a non-empty directory",
      shell_output("#{bin}/cdk8s init python-app 2>&1", 1)
  end
end