class Sf < Formula
  desc "Command-line toolkit for Salesforce development"
  homepage "https://developer.salesforce.com/tools/salesforcecli"
  url "https://registry.npmjs.org/@salesforce/cli/-/cli-2.78.3.tgz"
  sha256 "97c87ceae00bf8645c51bd92ae68b4c43f6c17a1c504e4b171f8e5dbb5b75c21"
  license "BSD-3-Clause"

  livecheck do
    url "https://registry.npmjs.org/@salesforce/cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3dd802e95b0e5ea6b7ea0b4f77a2dcec6950a538d07feec25a1954cd7d0453c1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3dd802e95b0e5ea6b7ea0b4f77a2dcec6950a538d07feec25a1954cd7d0453c1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3dd802e95b0e5ea6b7ea0b4f77a2dcec6950a538d07feec25a1954cd7d0453c1"
    sha256 cellar: :any_skip_relocation, sonoma:        "31199404045cb9301e0f58219a5af723b0b768bc3810682fbc2a297d9fa03f6f"
    sha256 cellar: :any_skip_relocation, ventura:       "31199404045cb9301e0f58219a5af723b0b768bc3810682fbc2a297d9fa03f6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3dd802e95b0e5ea6b7ea0b4f77a2dcec6950a538d07feec25a1954cd7d0453c1"
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