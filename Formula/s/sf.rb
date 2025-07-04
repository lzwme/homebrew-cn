class Sf < Formula
  desc "Command-line toolkit for Salesforce development"
  homepage "https://developer.salesforce.com/tools/salesforcecli"
  url "https://registry.npmjs.org/@salesforce/cli/-/cli-2.95.6.tgz"
  sha256 "2ee18e59a41c3930ab3f240639e5bb4fd0c053ef8bc67913af0d77a2789ac711"
  license "BSD-3-Clause"

  livecheck do
    url "https://registry.npmjs.org/@salesforce/cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "04a07925ff8833089caafef75028abc235487bf395ace8033a5d8df03020ba88"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "04a07925ff8833089caafef75028abc235487bf395ace8033a5d8df03020ba88"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "04a07925ff8833089caafef75028abc235487bf395ace8033a5d8df03020ba88"
    sha256 cellar: :any_skip_relocation, sonoma:        "673ccf65df1040d282e2c3f633a22facc1ebcecf08ce2e43c345a1d06420f4be"
    sha256 cellar: :any_skip_relocation, ventura:       "673ccf65df1040d282e2c3f633a22facc1ebcecf08ce2e43c345a1d06420f4be"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "04a07925ff8833089caafef75028abc235487bf395ace8033a5d8df03020ba88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "04a07925ff8833089caafef75028abc235487bf395ace8033a5d8df03020ba88"
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