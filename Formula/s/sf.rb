class Sf < Formula
  desc "Command-line toolkit for Salesforce development"
  homepage "https://developer.salesforce.com/tools/salesforcecli"
  url "https://registry.npmjs.org/@salesforce/cli/-/cli-2.63.8.tgz"
  sha256 "b80c2697c0176e90ff22fae0fe6e7eb951115607461c6a044d0f81babc964bf2"
  license "BSD-3-Clause"

  livecheck do
    url "https://registry.npmjs.org/@salesforce/cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ab89474393013993255ec5a15b1d063d93ddc8bf706289cfc9cefdc13718d371"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ab89474393013993255ec5a15b1d063d93ddc8bf706289cfc9cefdc13718d371"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ab89474393013993255ec5a15b1d063d93ddc8bf706289cfc9cefdc13718d371"
    sha256 cellar: :any_skip_relocation, sonoma:        "edd440a3037296fa5027d134020e093ba9d376cd7503227ae393e153624d8c3a"
    sha256 cellar: :any_skip_relocation, ventura:       "edd440a3037296fa5027d134020e093ba9d376cd7503227ae393e153624d8c3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab89474393013993255ec5a15b1d063d93ddc8bf706289cfc9cefdc13718d371"
  end

  depends_on "node@20"

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