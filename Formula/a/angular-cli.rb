class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-20.1.4.tgz"
  sha256 "39d5f04319131fbb1c1193c687070962faf031fca84cc38474391b473a5455be"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "19c5d1ff2d524d0acfaedebc8782975ec39846db3d9a9a12914e11a5c528093c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "19c5d1ff2d524d0acfaedebc8782975ec39846db3d9a9a12914e11a5c528093c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "19c5d1ff2d524d0acfaedebc8782975ec39846db3d9a9a12914e11a5c528093c"
    sha256 cellar: :any_skip_relocation, sonoma:        "fecb4508a870ac68852b59a7ce0e5806303fabc2b96a25acab6a0cc5570fa0f5"
    sha256 cellar: :any_skip_relocation, ventura:       "fecb4508a870ac68852b59a7ce0e5806303fabc2b96a25acab6a0cc5570fa0f5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "19c5d1ff2d524d0acfaedebc8782975ec39846db3d9a9a12914e11a5c528093c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "19c5d1ff2d524d0acfaedebc8782975ec39846db3d9a9a12914e11a5c528093c"
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