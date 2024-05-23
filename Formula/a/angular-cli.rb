require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-17.3.8.tgz"
  sha256 "142cc3738e947d933bf811b94d37b6c72a4a30d5d8ef34afac2f5ab4cda4a3e3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "252b5d452d8e004ceae413128d9cae595829bca478566978e6f4c8c1c7a3f89f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f5f47f923117a643f7608a85420418a63e6c4a63e31e691bd6abf451181e75d5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "00f9b21341dcccb1dd2bfca0506e1cba02fa98d62473a6a206a8088b341c86c3"
    sha256 cellar: :any_skip_relocation, sonoma:         "d030fd900fa753549c812e24a42ae66ee328e96e49a11424a6e657f8531199a1"
    sha256 cellar: :any_skip_relocation, ventura:        "cc285730b82708f33059917d2da7a3a3837cc271220fea09f8eea5da5d95868e"
    sha256 cellar: :any_skip_relocation, monterey:       "09607524073a22e9b8505d6c21c43f2018209cb0a1c7feef5407ddd404a60d58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ef404584da884211b3f550c207d88fc2e919a1ae86807660d785df4320b7a0cc"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"ng", "new", "angular-homebrew-test", "--skip-install"
    assert_predicate testpath/"angular-homebrew-test/package.json", :exist?, "Project was not created"
  end
end