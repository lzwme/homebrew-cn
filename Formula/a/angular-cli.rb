class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-19.0.4.tgz"
  sha256 "e432542f6794ca21c8e79d4d73f9294c8148ebda93535cb6d5cead61246e207e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "411326632b56deb643f89a2b0f627937ada676497b1612c7305ef2b3b3b4cf36"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "411326632b56deb643f89a2b0f627937ada676497b1612c7305ef2b3b3b4cf36"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "411326632b56deb643f89a2b0f627937ada676497b1612c7305ef2b3b3b4cf36"
    sha256 cellar: :any_skip_relocation, sonoma:        "518a556032bb8e5991a401a1e67ed55d6e2217fc99d3f32c95ccd100b00eac5c"
    sha256 cellar: :any_skip_relocation, ventura:       "518a556032bb8e5991a401a1e67ed55d6e2217fc99d3f32c95ccd100b00eac5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "411326632b56deb643f89a2b0f627937ada676497b1612c7305ef2b3b3b4cf36"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"ng", "new", "angular-homebrew-test", "--skip-install"
    assert_predicate testpath/"angular-homebrew-test/package.json", :exist?, "Project was not created"
  end
end