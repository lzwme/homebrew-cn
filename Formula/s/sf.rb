class Sf < Formula
  desc "Command-line toolkit for Salesforce development"
  homepage "https://developer.salesforce.com/tools/salesforcecli"
  url "https://registry.npmjs.org/@salesforce/cli/-/cli-2.69.14.tgz"
  sha256 "48f2698611ab7822312038c67b054e6d5d22d912e7c2cf93d5e8ba5be7738b5d"
  license "BSD-3-Clause"

  livecheck do
    url "https://registry.npmjs.org/@salesforce/cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "db7bed28b74c9152015664a2decd0871d47a1ff9ce0fc0d1d2801b06cbc6c24f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "db7bed28b74c9152015664a2decd0871d47a1ff9ce0fc0d1d2801b06cbc6c24f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "db7bed28b74c9152015664a2decd0871d47a1ff9ce0fc0d1d2801b06cbc6c24f"
    sha256 cellar: :any_skip_relocation, sonoma:        "9213375a9e6f18da6ce4e7818a8444fd1e574d6232d79a07bd684d75264369dc"
    sha256 cellar: :any_skip_relocation, ventura:       "9213375a9e6f18da6ce4e7818a8444fd1e574d6232d79a07bd684d75264369dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "db7bed28b74c9152015664a2decd0871d47a1ff9ce0fc0d1d2801b06cbc6c24f"
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