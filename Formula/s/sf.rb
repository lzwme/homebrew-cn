class Sf < Formula
  desc "Command-line toolkit for Salesforce development"
  homepage "https://developer.salesforce.com/tools/salesforcecli"
  url "https://registry.npmjs.org/@salesforce/cli/-/cli-2.74.6.tgz"
  sha256 "6db2d99aad460f6b2892d24fddd4161c432e8e5a4f998e65d36cfc9a196a8fe8"
  license "BSD-3-Clause"

  livecheck do
    url "https://registry.npmjs.org/@salesforce/cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c5ab678e617aa436249209808409f1877e462aabbc10b92c8624d4c7c38110b4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c5ab678e617aa436249209808409f1877e462aabbc10b92c8624d4c7c38110b4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c5ab678e617aa436249209808409f1877e462aabbc10b92c8624d4c7c38110b4"
    sha256 cellar: :any_skip_relocation, sonoma:        "3a02162df0bf33f8c025dc36a29d3f9f03860777d4273ed2224acae694541c7d"
    sha256 cellar: :any_skip_relocation, ventura:       "3a02162df0bf33f8c025dc36a29d3f9f03860777d4273ed2224acae694541c7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c5ab678e617aa436249209808409f1877e462aabbc10b92c8624d4c7c38110b4"
  end

  depends_on "node"

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