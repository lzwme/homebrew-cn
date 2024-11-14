class Sf < Formula
  desc "Command-line toolkit for Salesforce development"
  homepage "https://developer.salesforce.com/tools/salesforcecli"
  url "https://registry.npmjs.org/@salesforce/cli/-/cli-2.66.7.tgz"
  sha256 "f80563112e592e3b122767e6d8117339bdf564bccc64212db62835d48a6285ef"
  license "BSD-3-Clause"

  livecheck do
    url "https://registry.npmjs.org/@salesforce/cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9bfc35cef9f5ad44f1f072cab0b35b1c6723c7a8bb46f3aa43b8071f7a347895"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9bfc35cef9f5ad44f1f072cab0b35b1c6723c7a8bb46f3aa43b8071f7a347895"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9bfc35cef9f5ad44f1f072cab0b35b1c6723c7a8bb46f3aa43b8071f7a347895"
    sha256 cellar: :any_skip_relocation, sonoma:        "a48650d1cf01b58b05b5766e7f8512359f047a9f7f91b2d1a2232f210d36417b"
    sha256 cellar: :any_skip_relocation, ventura:       "a48650d1cf01b58b05b5766e7f8512359f047a9f7f91b2d1a2232f210d36417b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9bfc35cef9f5ad44f1f072cab0b35b1c6723c7a8bb46f3aa43b8071f7a347895"
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