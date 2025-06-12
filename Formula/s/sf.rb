class Sf < Formula
  desc "Command-line toolkit for Salesforce development"
  homepage "https://developer.salesforce.com/tools/salesforcecli"
  url "https://registry.npmjs.org/@salesforce/cli/-/cli-2.92.7.tgz"
  sha256 "29e4eb1ebd7d6c25f7cce6a902a03de094788afcf5600c3d58f5cf0d233ae633"
  license "BSD-3-Clause"

  livecheck do
    url "https://registry.npmjs.org/@salesforce/cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b1cbfeb732e2f2a29675fb9147bb912c46980fd34fde55e8a628827ca3704e0d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b1cbfeb732e2f2a29675fb9147bb912c46980fd34fde55e8a628827ca3704e0d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b1cbfeb732e2f2a29675fb9147bb912c46980fd34fde55e8a628827ca3704e0d"
    sha256 cellar: :any_skip_relocation, sonoma:        "8f5c57fee3b082ddb0f9a6e3aacc21bcbcc301064a8ea525e4e12af905b25f09"
    sha256 cellar: :any_skip_relocation, ventura:       "8f5c57fee3b082ddb0f9a6e3aacc21bcbcc301064a8ea525e4e12af905b25f09"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b1cbfeb732e2f2a29675fb9147bb912c46980fd34fde55e8a628827ca3704e0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b1cbfeb732e2f2a29675fb9147bb912c46980fd34fde55e8a628827ca3704e0d"
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