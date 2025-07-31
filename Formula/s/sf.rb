class Sf < Formula
  desc "Command-line toolkit for Salesforce development"
  homepage "https://developer.salesforce.com/tools/salesforcecli"
  url "https://registry.npmjs.org/@salesforce/cli/-/cli-2.99.6.tgz"
  sha256 "55f8225dd82f2a28450ef87f20aabcf4388e89da91fd0111c59817b9bf9f8af8"
  license "BSD-3-Clause"

  livecheck do
    url "https://registry.npmjs.org/@salesforce/cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3b81cdaac1f8c1c7ba98fc0270ff01d795f5b385c990fdecfd63ce77c12fb39f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3b81cdaac1f8c1c7ba98fc0270ff01d795f5b385c990fdecfd63ce77c12fb39f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3b81cdaac1f8c1c7ba98fc0270ff01d795f5b385c990fdecfd63ce77c12fb39f"
    sha256 cellar: :any_skip_relocation, sonoma:        "a38c44f58a2b60ec1ee0835113be2e709789c806b200daa980f28f1b57deadeb"
    sha256 cellar: :any_skip_relocation, ventura:       "a38c44f58a2b60ec1ee0835113be2e709789c806b200daa980f28f1b57deadeb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3b81cdaac1f8c1c7ba98fc0270ff01d795f5b385c990fdecfd63ce77c12fb39f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b81cdaac1f8c1c7ba98fc0270ff01d795f5b385c990fdecfd63ce77c12fb39f"
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