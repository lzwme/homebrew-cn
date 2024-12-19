class Sf < Formula
  desc "Command-line toolkit for Salesforce development"
  homepage "https://developer.salesforce.com/tools/salesforcecli"
  url "https://registry.npmjs.org/@salesforce/cli/-/cli-2.70.7.tgz"
  sha256 "c859bb30e8eadcdc90076442a9b3db541db02c774592038ffbf01be56b7ecead"
  license "BSD-3-Clause"

  livecheck do
    url "https://registry.npmjs.org/@salesforce/cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b91d5a371d48aa871bb0ea1674b69c566e42d4faaffcfde8ce8bba545c43de64"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b91d5a371d48aa871bb0ea1674b69c566e42d4faaffcfde8ce8bba545c43de64"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b91d5a371d48aa871bb0ea1674b69c566e42d4faaffcfde8ce8bba545c43de64"
    sha256 cellar: :any_skip_relocation, sonoma:        "5939a2af15cfcb863a6d2f21e4e4cd2fcc7c729cba322abcb34883132d9e0b5f"
    sha256 cellar: :any_skip_relocation, ventura:       "5939a2af15cfcb863a6d2f21e4e4cd2fcc7c729cba322abcb34883132d9e0b5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b91d5a371d48aa871bb0ea1674b69c566e42d4faaffcfde8ce8bba545c43de64"
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