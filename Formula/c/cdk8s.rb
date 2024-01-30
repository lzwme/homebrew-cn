require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.36.tgz"
  sha256 "ee4d43a68b82e109551550a888af1cac8a677bb5fc1448c8e2848d58b2fed082"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "60c0dddafa3438c264ab801c055f830f1ef6b5f4d87d6dde706e170917b87529"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "60c0dddafa3438c264ab801c055f830f1ef6b5f4d87d6dde706e170917b87529"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "60c0dddafa3438c264ab801c055f830f1ef6b5f4d87d6dde706e170917b87529"
    sha256 cellar: :any_skip_relocation, sonoma:         "35b8a3368832a09564ec79257b905517d8fe053a8deb169c989bf82071e7a5ea"
    sha256 cellar: :any_skip_relocation, ventura:        "35b8a3368832a09564ec79257b905517d8fe053a8deb169c989bf82071e7a5ea"
    sha256 cellar: :any_skip_relocation, monterey:       "35b8a3368832a09564ec79257b905517d8fe053a8deb169c989bf82071e7a5ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "60c0dddafa3438c264ab801c055f830f1ef6b5f4d87d6dde706e170917b87529"
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