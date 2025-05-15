class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-19.2.12.tgz"
  sha256 "9683cb35af52d1908ac4e5f6b20b174d115dbe68d043251535a3ea9bae9eed2c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "133681b5ed2bdeb65a921565e754b9b8c1783ac3caadf9901de8ff12686ab970"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "133681b5ed2bdeb65a921565e754b9b8c1783ac3caadf9901de8ff12686ab970"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "133681b5ed2bdeb65a921565e754b9b8c1783ac3caadf9901de8ff12686ab970"
    sha256 cellar: :any_skip_relocation, sonoma:        "48d59d0f390a1008e9ad2c07a6ef7fb32c4d98cb0cba97cab065e6bf4dd05093"
    sha256 cellar: :any_skip_relocation, ventura:       "48d59d0f390a1008e9ad2c07a6ef7fb32c4d98cb0cba97cab065e6bf4dd05093"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "133681b5ed2bdeb65a921565e754b9b8c1783ac3caadf9901de8ff12686ab970"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "133681b5ed2bdeb65a921565e754b9b8c1783ac3caadf9901de8ff12686ab970"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"ng", "new", "angular-homebrew-test", "--skip-install"
    assert_path_exists testpath/"angular-homebrew-test/package.json", "Project was not created"
  end
end