require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.30.tgz"
  sha256 "32d78668466420482840af9220ccc198309246786b7151d16bf1077eedf34f3b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "82c893ebf7840eead2b0ab8257817b97840079a4a1f77d415f87d265568d7e8b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "82c893ebf7840eead2b0ab8257817b97840079a4a1f77d415f87d265568d7e8b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "82c893ebf7840eead2b0ab8257817b97840079a4a1f77d415f87d265568d7e8b"
    sha256 cellar: :any_skip_relocation, sonoma:         "0b28655646d78085e32ea62f7387241cadd449171abe288be3bc06751971590b"
    sha256 cellar: :any_skip_relocation, ventura:        "0b28655646d78085e32ea62f7387241cadd449171abe288be3bc06751971590b"
    sha256 cellar: :any_skip_relocation, monterey:       "0b28655646d78085e32ea62f7387241cadd449171abe288be3bc06751971590b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "82c893ebf7840eead2b0ab8257817b97840079a4a1f77d415f87d265568d7e8b"
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