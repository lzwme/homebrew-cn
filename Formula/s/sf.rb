class Sf < Formula
  desc "Command-line toolkit for Salesforce development"
  homepage "https://developer.salesforce.com/tools/salesforcecli"
  url "https://registry.npmjs.org/@salesforce/cli/-/cli-2.100.3.tgz"
  sha256 "321d2734541a1c48a25497183792609ceb7baea87c3e3d30c275cfcb679ead58"
  license "BSD-3-Clause"

  livecheck do
    url "https://registry.npmjs.org/@salesforce/cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "24f863af9367abf3b72500944c0ce1bfdef7190d53d546e43422d6abd0c71a9d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "24f863af9367abf3b72500944c0ce1bfdef7190d53d546e43422d6abd0c71a9d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "24f863af9367abf3b72500944c0ce1bfdef7190d53d546e43422d6abd0c71a9d"
    sha256 cellar: :any_skip_relocation, sonoma:        "62f7bd00f5c2f1d3ec1711d3cc47c0f4feb60cb9ee86c6f8fd42422faba1f3b3"
    sha256 cellar: :any_skip_relocation, ventura:       "62f7bd00f5c2f1d3ec1711d3cc47c0f4feb60cb9ee86c6f8fd42422faba1f3b3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "24f863af9367abf3b72500944c0ce1bfdef7190d53d546e43422d6abd0c71a9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "24f863af9367abf3b72500944c0ce1bfdef7190d53d546e43422d6abd0c71a9d"
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