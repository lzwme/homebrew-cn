class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-20.1.1.tgz"
  sha256 "c7b1745622442eca05df4201d5407e12e696ac6b3f2496d2f1ea7a49fe61578e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c34e645129c8e3e690bf740eebce25c0d2767efaf093c369b4db4548021ad934"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c34e645129c8e3e690bf740eebce25c0d2767efaf093c369b4db4548021ad934"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c34e645129c8e3e690bf740eebce25c0d2767efaf093c369b4db4548021ad934"
    sha256 cellar: :any_skip_relocation, sonoma:        "8a0a7f966de57b7546723376835bcfd7f857bf02d80dd2d08e990ba2bfee1cf7"
    sha256 cellar: :any_skip_relocation, ventura:       "8a0a7f966de57b7546723376835bcfd7f857bf02d80dd2d08e990ba2bfee1cf7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c34e645129c8e3e690bf740eebce25c0d2767efaf093c369b4db4548021ad934"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c34e645129c8e3e690bf740eebce25c0d2767efaf093c369b4db4548021ad934"
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