class Sf < Formula
  desc "Command-line toolkit for Salesforce development"
  homepage "https://developer.salesforce.com/tools/salesforcecli"
  url "https://registry.npmjs.org/@salesforce/cli/-/cli-2.79.4.tgz"
  sha256 "19c00127a7dfc91e0e986477c249fc01e67644b0035fcd7821728781844ba2b6"
  license "BSD-3-Clause"

  livecheck do
    url "https://registry.npmjs.org/@salesforce/cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8eef361cda0b33ed7a8248db3e63fa97032c526c137b3b81a270ec39b1b348b7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8eef361cda0b33ed7a8248db3e63fa97032c526c137b3b81a270ec39b1b348b7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8eef361cda0b33ed7a8248db3e63fa97032c526c137b3b81a270ec39b1b348b7"
    sha256 cellar: :any_skip_relocation, sonoma:        "f14a974facf71b7e4869ba06a654df623381f7d99ed53b7699982ed9310d4c29"
    sha256 cellar: :any_skip_relocation, ventura:       "f14a974facf71b7e4869ba06a654df623381f7d99ed53b7699982ed9310d4c29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8eef361cda0b33ed7a8248db3e63fa97032c526c137b3b81a270ec39b1b348b7"
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