class Sf < Formula
  desc "Command-line toolkit for Salesforce development"
  homepage "https://developer.salesforce.com/tools/salesforcecli"
  url "https://registry.npmjs.org/@salesforce/cli/-/cli-2.98.6.tgz"
  sha256 "80e70ac0e73ce124068856c6b29a9e846dc50a556350f4fb98744cae8eecb85a"
  license "BSD-3-Clause"

  livecheck do
    url "https://registry.npmjs.org/@salesforce/cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a07b03fded245e0ee431523571c99ad07579dbaf64bd2db80c2b6a7990c5dba5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a07b03fded245e0ee431523571c99ad07579dbaf64bd2db80c2b6a7990c5dba5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a07b03fded245e0ee431523571c99ad07579dbaf64bd2db80c2b6a7990c5dba5"
    sha256 cellar: :any_skip_relocation, sonoma:        "e3ba23dd5eb7f11930375d0a5fe63cfb93fe03bc01843b665f9c756f97df3049"
    sha256 cellar: :any_skip_relocation, ventura:       "e3ba23dd5eb7f11930375d0a5fe63cfb93fe03bc01843b665f9c756f97df3049"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a07b03fded245e0ee431523571c99ad07579dbaf64bd2db80c2b6a7990c5dba5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a07b03fded245e0ee431523571c99ad07579dbaf64bd2db80c2b6a7990c5dba5"
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