class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-20.1.3.tgz"
  sha256 "b8df2c7803c7a04ae5fc0b2778b2232a8a0586e20f37622da7130635c9443bd5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6017c8b7c3e0258f2a2acc03d79beffdcc0c118c43f9d1772ed9edfd50e84082"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6017c8b7c3e0258f2a2acc03d79beffdcc0c118c43f9d1772ed9edfd50e84082"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6017c8b7c3e0258f2a2acc03d79beffdcc0c118c43f9d1772ed9edfd50e84082"
    sha256 cellar: :any_skip_relocation, sonoma:        "75c3c6abb36d61908a81454a110b8f76dc0802230699f1e976279bd3f94066b3"
    sha256 cellar: :any_skip_relocation, ventura:       "75c3c6abb36d61908a81454a110b8f76dc0802230699f1e976279bd3f94066b3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6017c8b7c3e0258f2a2acc03d79beffdcc0c118c43f9d1772ed9edfd50e84082"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6017c8b7c3e0258f2a2acc03d79beffdcc0c118c43f9d1772ed9edfd50e84082"
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