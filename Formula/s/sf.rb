class Sf < Formula
  desc "Command-line toolkit for Salesforce development"
  homepage "https://developer.salesforce.com/tools/salesforcecli"
  url "https://registry.npmjs.org/@salesforce/cli/-/cli-2.68.6.tgz"
  sha256 "ef05660ef80c040accb0f4fd5c09624d3d28d3affbdae71262951da6ab1444a4"
  license "BSD-3-Clause"

  livecheck do
    url "https://registry.npmjs.org/@salesforce/cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1612f6197f2d648d552ae853b6e6aac8db96553d621b5848555e67fda9168f34"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1612f6197f2d648d552ae853b6e6aac8db96553d621b5848555e67fda9168f34"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1612f6197f2d648d552ae853b6e6aac8db96553d621b5848555e67fda9168f34"
    sha256 cellar: :any_skip_relocation, sonoma:        "62372d900455946ae59f5fc7dd9b15ab354bbcd1145fd385219ef92a53d7616f"
    sha256 cellar: :any_skip_relocation, ventura:       "62372d900455946ae59f5fc7dd9b15ab354bbcd1145fd385219ef92a53d7616f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1612f6197f2d648d552ae853b6e6aac8db96553d621b5848555e67fda9168f34"
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