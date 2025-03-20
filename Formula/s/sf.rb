class Sf < Formula
  desc "Command-line toolkit for Salesforce development"
  homepage "https://developer.salesforce.com/tools/salesforcecli"
  url "https://registry.npmjs.org/@salesforce/cli/-/cli-2.80.12.tgz"
  sha256 "737cf7ab9bd340bb3d54b9065e4df1f33ec6357852ff155cf63dbce75e8c3790"
  license "BSD-3-Clause"

  livecheck do
    url "https://registry.npmjs.org/@salesforce/cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "495e6344a27a230cb0efd8f49ac4a76dd1a8aaf18fa4c14c83434e3de1dafee2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "495e6344a27a230cb0efd8f49ac4a76dd1a8aaf18fa4c14c83434e3de1dafee2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "495e6344a27a230cb0efd8f49ac4a76dd1a8aaf18fa4c14c83434e3de1dafee2"
    sha256 cellar: :any_skip_relocation, sonoma:        "59cca1814e4783f3e074e85eccd6250ecb0ae733fe4d6e4c78f5c84a8ef73dfb"
    sha256 cellar: :any_skip_relocation, ventura:       "59cca1814e4783f3e074e85eccd6250ecb0ae733fe4d6e4c78f5c84a8ef73dfb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "495e6344a27a230cb0efd8f49ac4a76dd1a8aaf18fa4c14c83434e3de1dafee2"
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