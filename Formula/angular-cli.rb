require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-16.1.8.tgz"
  sha256 "4e09929c76b8b4e897f8e66f79a08aa809e2f1961f33daa0f85fc1c2f9fa19a9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ee35bbb855c83e1873a7014c45101c370341785fdbf24113aab126edb9b4ff2f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ee35bbb855c83e1873a7014c45101c370341785fdbf24113aab126edb9b4ff2f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ee35bbb855c83e1873a7014c45101c370341785fdbf24113aab126edb9b4ff2f"
    sha256 cellar: :any_skip_relocation, ventura:        "c09ad4a394c65a2986072c1ff1f083bc31fa95c09a0837f4b12d5b8066773cdf"
    sha256 cellar: :any_skip_relocation, monterey:       "c09ad4a394c65a2986072c1ff1f083bc31fa95c09a0837f4b12d5b8066773cdf"
    sha256 cellar: :any_skip_relocation, big_sur:        "c09ad4a394c65a2986072c1ff1f083bc31fa95c09a0837f4b12d5b8066773cdf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee35bbb855c83e1873a7014c45101c370341785fdbf24113aab126edb9b4ff2f"
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