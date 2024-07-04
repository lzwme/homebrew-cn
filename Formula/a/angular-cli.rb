require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli"
  url "https://registry.npmjs.org/@angular/cli/-/cli-18.0.7.tgz"
  sha256 "863145e2357ae0f5469218a8bd6050d280c60f00eac70da5395ff106a79bd4e1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e93ff500e44cd40bbbe5f452555c8c4dc0a01852c2e8c826c33bdc329b660d7a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e93ff500e44cd40bbbe5f452555c8c4dc0a01852c2e8c826c33bdc329b660d7a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e93ff500e44cd40bbbe5f452555c8c4dc0a01852c2e8c826c33bdc329b660d7a"
    sha256 cellar: :any_skip_relocation, sonoma:         "0428a90e5925f7f8da7ad78da01e989f0131dd77c5d5cb4683c39c9dad9c5fc3"
    sha256 cellar: :any_skip_relocation, ventura:        "0428a90e5925f7f8da7ad78da01e989f0131dd77c5d5cb4683c39c9dad9c5fc3"
    sha256 cellar: :any_skip_relocation, monterey:       "0428a90e5925f7f8da7ad78da01e989f0131dd77c5d5cb4683c39c9dad9c5fc3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "860cbd8f9538f4d3b31118a92f1d123898a807406669cf566ceea407c2116165"
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