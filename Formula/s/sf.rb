class Sf < Formula
  desc "Command-line toolkit for Salesforce development"
  homepage "https://developer.salesforce.com/tools/salesforcecli"
  url "https://registry.npmjs.org/@salesforce/cli/-/cli-2.64.8.tgz"
  sha256 "cad27a8c318cc19bde031257084bb9ac19668a409a73e2d196ac697c40d785a2"
  license "BSD-3-Clause"

  livecheck do
    url "https://registry.npmjs.org/@salesforce/cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5692600933e1b12c5ce3900669965f94020563944b11845f62b171be8c7d39ef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5692600933e1b12c5ce3900669965f94020563944b11845f62b171be8c7d39ef"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5692600933e1b12c5ce3900669965f94020563944b11845f62b171be8c7d39ef"
    sha256 cellar: :any_skip_relocation, sonoma:        "56039a3354b55de48feb1dd9429458342b61e0d6b318967df51ea46cba9cabda"
    sha256 cellar: :any_skip_relocation, ventura:       "56039a3354b55de48feb1dd9429458342b61e0d6b318967df51ea46cba9cabda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5692600933e1b12c5ce3900669965f94020563944b11845f62b171be8c7d39ef"
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