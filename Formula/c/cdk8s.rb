class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.200.112.tgz"
  sha256 "a6ca22b456f66a4dad4584a382a2fefc8ca93134d1efe91ea2caa44cd17b4e45"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c58a87c6a54aa7389d54fcdb641b3aac46203b01eb96648f3f3e7d1425fd54fb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c58a87c6a54aa7389d54fcdb641b3aac46203b01eb96648f3f3e7d1425fd54fb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c58a87c6a54aa7389d54fcdb641b3aac46203b01eb96648f3f3e7d1425fd54fb"
    sha256 cellar: :any_skip_relocation, sonoma:        "e81e563b50d4635cceb26ff63ef52c0c55e9c587e40eb0778827804ad9975398"
    sha256 cellar: :any_skip_relocation, ventura:       "e81e563b50d4635cceb26ff63ef52c0c55e9c587e40eb0778827804ad9975398"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c58a87c6a54aa7389d54fcdb641b3aac46203b01eb96648f3f3e7d1425fd54fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c58a87c6a54aa7389d54fcdb641b3aac46203b01eb96648f3f3e7d1425fd54fb"
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