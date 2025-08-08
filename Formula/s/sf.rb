class Sf < Formula
  desc "Command-line toolkit for Salesforce development"
  homepage "https://developer.salesforce.com/tools/salesforcecli"
  url "https://registry.npmjs.org/@salesforce/cli/-/cli-2.100.4.tgz"
  sha256 "05d5c2917788d2a2b6ea55895cbed59b5f48d82561efcdaf4a1f9a0040592547"
  license "BSD-3-Clause"

  livecheck do
    url "https://registry.npmjs.org/@salesforce/cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "362860a5a9554e45428f790de613a26811fa5a8590768006e24e72cdf3be3121"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "362860a5a9554e45428f790de613a26811fa5a8590768006e24e72cdf3be3121"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "362860a5a9554e45428f790de613a26811fa5a8590768006e24e72cdf3be3121"
    sha256 cellar: :any_skip_relocation, sonoma:        "b463263ba3af28849bee8840ed8aa4f78031eed22b9102f07b98baed780e8cba"
    sha256 cellar: :any_skip_relocation, ventura:       "b463263ba3af28849bee8840ed8aa4f78031eed22b9102f07b98baed780e8cba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "362860a5a9554e45428f790de613a26811fa5a8590768006e24e72cdf3be3121"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "362860a5a9554e45428f790de613a26811fa5a8590768006e24e72cdf3be3121"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"sf", "project", "generate", "-n", "projectname", "-t", "empty"
    assert_path_exists testpath/"projectname"
    assert_path_exists testpath/"projectname/config/project-scratch-def.json"
    assert_path_exists testpath/"projectname/README.md"
    assert_path_exists testpath/"projectname/sfdx-project.json"
    assert_path_exists testpath/"projectname/.forceignore"
  end
end