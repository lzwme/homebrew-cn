class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-19.2.5.tgz"
  sha256 "496f3cd5de808c825190cc5efcc81fe4dc13d045f3dd9c88bc91d67c15fc5734"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "649c8b2fd330194670133eb2ba44230dde14b3715f5ae9641d8809a3bda389d1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "649c8b2fd330194670133eb2ba44230dde14b3715f5ae9641d8809a3bda389d1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "649c8b2fd330194670133eb2ba44230dde14b3715f5ae9641d8809a3bda389d1"
    sha256 cellar: :any_skip_relocation, sonoma:        "f1e8546e5907d0b401e1bcadc491018465b392061cd47fe0f70db0c88e689f82"
    sha256 cellar: :any_skip_relocation, ventura:       "f1e8546e5907d0b401e1bcadc491018465b392061cd47fe0f70db0c88e689f82"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "649c8b2fd330194670133eb2ba44230dde14b3715f5ae9641d8809a3bda389d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "649c8b2fd330194670133eb2ba44230dde14b3715f5ae9641d8809a3bda389d1"
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