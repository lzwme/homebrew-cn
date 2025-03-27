class Sf < Formula
  desc "Command-line toolkit for Salesforce development"
  homepage "https://developer.salesforce.com/tools/salesforcecli"
  url "https://registry.npmjs.org/@salesforce/cli/-/cli-2.81.9.tgz"
  sha256 "4e5e805d27fb61b63e9cc622cbd6ff955efe72f0bef323d2e873fa3ab82f64ef"
  license "BSD-3-Clause"

  livecheck do
    url "https://registry.npmjs.org/@salesforce/cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "607b840c026d53f84c167c2f6f80f691804e1080b3a18e9477f19a7bb70d397c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "607b840c026d53f84c167c2f6f80f691804e1080b3a18e9477f19a7bb70d397c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "607b840c026d53f84c167c2f6f80f691804e1080b3a18e9477f19a7bb70d397c"
    sha256 cellar: :any_skip_relocation, sonoma:        "82153fb06497ab0d26580ac7359645486df647f6cbac6b78bf24e9f9c2142c7c"
    sha256 cellar: :any_skip_relocation, ventura:       "82153fb06497ab0d26580ac7359645486df647f6cbac6b78bf24e9f9c2142c7c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "607b840c026d53f84c167c2f6f80f691804e1080b3a18e9477f19a7bb70d397c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "607b840c026d53f84c167c2f6f80f691804e1080b3a18e9477f19a7bb70d397c"
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