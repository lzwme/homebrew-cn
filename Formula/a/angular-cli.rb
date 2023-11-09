require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-17.0.0.tgz"
  sha256 "4d33a6fdc645417353130fc3e2d05eed4f8eb555490a4e44e34b4cbed13f74d1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "df80bfa0ff8ab88a83d4320eeb3034c32864c0151882b0be77eef9f423977038"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "df80bfa0ff8ab88a83d4320eeb3034c32864c0151882b0be77eef9f423977038"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "df80bfa0ff8ab88a83d4320eeb3034c32864c0151882b0be77eef9f423977038"
    sha256 cellar: :any_skip_relocation, sonoma:         "f6f78dd54534a647b0b782d1218044241534d621a6620502abc48d0348255a82"
    sha256 cellar: :any_skip_relocation, ventura:        "f6f78dd54534a647b0b782d1218044241534d621a6620502abc48d0348255a82"
    sha256 cellar: :any_skip_relocation, monterey:       "f6f78dd54534a647b0b782d1218044241534d621a6620502abc48d0348255a82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "df80bfa0ff8ab88a83d4320eeb3034c32864c0151882b0be77eef9f423977038"
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