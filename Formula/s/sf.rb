class Sf < Formula
  desc "Command-line toolkit for Salesforce development"
  homepage "https://developer.salesforce.com/tools/salesforcecli"
  url "https://registry.npmjs.org/@salesforce/cli/-/cli-2.94.6.tgz"
  sha256 "7151c70799218ad2ce44ca9160f040170f335a4cbc4be06adc6f268cac0d90fe"
  license "BSD-3-Clause"

  livecheck do
    url "https://registry.npmjs.org/@salesforce/cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "44f399ae485dfda50f41536a185331529e58f10883aeccc427b7a22a7174ed8a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "44f399ae485dfda50f41536a185331529e58f10883aeccc427b7a22a7174ed8a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "44f399ae485dfda50f41536a185331529e58f10883aeccc427b7a22a7174ed8a"
    sha256 cellar: :any_skip_relocation, sonoma:        "34ed9bbe24fd5d3f96020cb1f60a207d7249444279fa94b2a57c1587489dda38"
    sha256 cellar: :any_skip_relocation, ventura:       "34ed9bbe24fd5d3f96020cb1f60a207d7249444279fa94b2a57c1587489dda38"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "44f399ae485dfda50f41536a185331529e58f10883aeccc427b7a22a7174ed8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "44f399ae485dfda50f41536a185331529e58f10883aeccc427b7a22a7174ed8a"
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