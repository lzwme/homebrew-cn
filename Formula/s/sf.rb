class Sf < Formula
  desc "Command-line toolkit for Salesforce development"
  homepage "https://developer.salesforce.com/tools/salesforcecli"
  url "https://registry.npmjs.org/@salesforce/cli/-/cli-2.97.6.tgz"
  sha256 "90cd265ba4dbde40b2f6dd54d662718ccd045360d182cf2e55f16c1a7d4d5a3d"
  license "BSD-3-Clause"

  livecheck do
    url "https://registry.npmjs.org/@salesforce/cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b34cbb2dfc8ec42f1c80f495d2840ade40d6c25327841c4300b92d9913fe601b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b34cbb2dfc8ec42f1c80f495d2840ade40d6c25327841c4300b92d9913fe601b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b34cbb2dfc8ec42f1c80f495d2840ade40d6c25327841c4300b92d9913fe601b"
    sha256 cellar: :any_skip_relocation, sonoma:        "f7771e2d01762f421d9ef6378739bd9a8083c24156e414d1027696a7db747f60"
    sha256 cellar: :any_skip_relocation, ventura:       "f7771e2d01762f421d9ef6378739bd9a8083c24156e414d1027696a7db747f60"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b34cbb2dfc8ec42f1c80f495d2840ade40d6c25327841c4300b92d9913fe601b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b34cbb2dfc8ec42f1c80f495d2840ade40d6c25327841c4300b92d9913fe601b"
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