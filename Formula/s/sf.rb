class Sf < Formula
  desc "Command-line toolkit for Salesforce development"
  homepage "https://developer.salesforce.com/tools/salesforcecli"
  url "https://registry.npmjs.org/@salesforce/cli/-/cli-2.65.8.tgz"
  sha256 "bd0cb536b58646433656a7011e5f174ac872e4697b7ac6ed06786907af7d7b62"
  license "BSD-3-Clause"

  livecheck do
    url "https://registry.npmjs.org/@salesforce/cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a5b55a666718de787c11405dee60f1954c0a6a242d9054936b22f22e815d9fa6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a5b55a666718de787c11405dee60f1954c0a6a242d9054936b22f22e815d9fa6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a5b55a666718de787c11405dee60f1954c0a6a242d9054936b22f22e815d9fa6"
    sha256 cellar: :any_skip_relocation, sonoma:        "e18372c6fb5b7d89a4c750976535b3a22bb2c3c99142825358321d3fa510e294"
    sha256 cellar: :any_skip_relocation, ventura:       "e18372c6fb5b7d89a4c750976535b3a22bb2c3c99142825358321d3fa510e294"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a5b55a666718de787c11405dee60f1954c0a6a242d9054936b22f22e815d9fa6"
  end

  depends_on "node@20"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"sf", "project", "generate", "-n", "projectname", "-t", "empty"
    assert_predicate testpath/"projectname", :exist?
    assert_predicate testpath/"projectname/config/project-scratch-def.json", :exist?
    assert_predicate testpath/"projectname/README.md", :exist?
    assert_predicate testpath/"projectname/sfdx-project.json", :exist?
    assert_predicate testpath/"projectname/.forceignore", :exist?
  end
end