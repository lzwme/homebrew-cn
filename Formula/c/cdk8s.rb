class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.200.115.tgz"
  sha256 "f30d477e56d967fdb0f12709b2ebcfc55683d98d42c2942b21b99f724a113804"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f237fe8dd1d974ca5c2e894d932ae915271002f651b1f46fcb57664a30b8fa91"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f237fe8dd1d974ca5c2e894d932ae915271002f651b1f46fcb57664a30b8fa91"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f237fe8dd1d974ca5c2e894d932ae915271002f651b1f46fcb57664a30b8fa91"
    sha256 cellar: :any_skip_relocation, sonoma:        "0f61fc6b1dd85ff5086e4ed73ffa4e5a72d4a748521860e150651526a81b89a2"
    sha256 cellar: :any_skip_relocation, ventura:       "0f61fc6b1dd85ff5086e4ed73ffa4e5a72d4a748521860e150651526a81b89a2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f237fe8dd1d974ca5c2e894d932ae915271002f651b1f46fcb57664a30b8fa91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f237fe8dd1d974ca5c2e894d932ae915271002f651b1f46fcb57664a30b8fa91"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/cdk8s init python-app 2>&1", 1)
    assert_match "Initializing a project from the python-app template", output
  end
end