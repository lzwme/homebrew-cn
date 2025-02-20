class Sf < Formula
  desc "Command-line toolkit for Salesforce development"
  homepage "https://developer.salesforce.com/tools/salesforcecli"
  url "https://registry.npmjs.org/@salesforce/cli/-/cli-2.77.6.tgz"
  sha256 "30a7a8bc281dfd92407b9b45464ebe639502e72cb0e5d6a5013ba7de0ffa9102"
  license "BSD-3-Clause"

  livecheck do
    url "https://registry.npmjs.org/@salesforce/cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "25d12bdef5e69eec830b81c83ce061527f93b24e3ec276ef9a39d644fd0bef23"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "25d12bdef5e69eec830b81c83ce061527f93b24e3ec276ef9a39d644fd0bef23"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "25d12bdef5e69eec830b81c83ce061527f93b24e3ec276ef9a39d644fd0bef23"
    sha256 cellar: :any_skip_relocation, sonoma:        "8f7ba8a80818937358cfcd39b69e2607a23cae9ebe10a374be28d91ed15b4b73"
    sha256 cellar: :any_skip_relocation, ventura:       "8f7ba8a80818937358cfcd39b69e2607a23cae9ebe10a374be28d91ed15b4b73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "25d12bdef5e69eec830b81c83ce061527f93b24e3ec276ef9a39d644fd0bef23"
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