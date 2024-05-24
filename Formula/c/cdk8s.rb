require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.126.tgz"
  sha256 "67d89653d426d86f60f9c1b39225da1d8296e381cbc9b6fba412310d34c216cc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f99535f792eeaff616f32150a4398865d812e463bc1ba8719cc6d2c7f6d730b5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1587b84cacfbc978f92f8659db046f7ef87dc82ee9b6729aeede4a3a73c3993b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0dc9d5b85a2b48b80bc3ed45fa7aa7ca2e7c7c73671b2cb88d0b1d0fad5ca130"
    sha256 cellar: :any_skip_relocation, sonoma:         "32207951be9368a4c38ec1c4e46377f48c50dfcc2fd5f70a88b9b1719f72ba8c"
    sha256 cellar: :any_skip_relocation, ventura:        "066bce084c75287586870a6d9c108b29800468543dc2d43ee60b33c81f83249f"
    sha256 cellar: :any_skip_relocation, monterey:       "c8166344669767279e361aeb911a9cbc4969a99eb42ea5fc8d66a314a186a1f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "df1485f2fbe15e244cd8a34ca895fdc2054eafe519353b020f21c38ef7c52b69"
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