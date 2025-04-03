class Sf < Formula
  desc "Command-line toolkit for Salesforce development"
  homepage "https://developer.salesforce.com/tools/salesforcecli"
  url "https://registry.npmjs.org/@salesforce/cli/-/cli-2.82.6.tgz"
  sha256 "48be549fd7ff3f5c3713f2d3479d6c9c0b8d554b6e772029f90312893fef67ae"
  license "BSD-3-Clause"

  livecheck do
    url "https://registry.npmjs.org/@salesforce/cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1be4e5879d706a2d35d31929e31997c40874c1c4409d83d2d9975e4a021c64c7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1be4e5879d706a2d35d31929e31997c40874c1c4409d83d2d9975e4a021c64c7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1be4e5879d706a2d35d31929e31997c40874c1c4409d83d2d9975e4a021c64c7"
    sha256 cellar: :any_skip_relocation, sonoma:        "dfd6cde9dc168e8fa81f14584f30194f88f906d6da2659ad0ce630b70cf2cfbf"
    sha256 cellar: :any_skip_relocation, ventura:       "dfd6cde9dc168e8fa81f14584f30194f88f906d6da2659ad0ce630b70cf2cfbf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1be4e5879d706a2d35d31929e31997c40874c1c4409d83d2d9975e4a021c64c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1be4e5879d706a2d35d31929e31997c40874c1c4409d83d2d9975e4a021c64c7"
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