class Sf < Formula
  desc "Command-line toolkit for Salesforce development"
  homepage "https://developer.salesforce.com/tools/salesforcecli"
  url "https://registry.npmjs.org/@salesforce/cli/-/cli-2.93.7.tgz"
  sha256 "3bdbd821c583c7b4e3ff79dd77f05090f7ebbfe0401847eca112b60306fcddbf"
  license "BSD-3-Clause"

  livecheck do
    url "https://registry.npmjs.org/@salesforce/cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3e42b8894ed553445df3002b7a81da83f76f0cda7f3c455bb436614dae91ac3c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3e42b8894ed553445df3002b7a81da83f76f0cda7f3c455bb436614dae91ac3c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3e42b8894ed553445df3002b7a81da83f76f0cda7f3c455bb436614dae91ac3c"
    sha256 cellar: :any_skip_relocation, sonoma:        "142bfec6c26fde737b70a971188b1854621db2247f3ac2221f7bdc0ea2df74e0"
    sha256 cellar: :any_skip_relocation, ventura:       "142bfec6c26fde737b70a971188b1854621db2247f3ac2221f7bdc0ea2df74e0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3e42b8894ed553445df3002b7a81da83f76f0cda7f3c455bb436614dae91ac3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e42b8894ed553445df3002b7a81da83f76f0cda7f3c455bb436614dae91ac3c"
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