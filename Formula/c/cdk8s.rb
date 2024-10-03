class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.234.tgz"
  sha256 "144fc3d85d77b7277bf4c2836345529201522a4fd813286590a3dc6b0fdb9735"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8686e4c1ccf438ed8466938f9648aed0c49c4160999ed6c0f63c5b9719c72f5f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8686e4c1ccf438ed8466938f9648aed0c49c4160999ed6c0f63c5b9719c72f5f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8686e4c1ccf438ed8466938f9648aed0c49c4160999ed6c0f63c5b9719c72f5f"
    sha256 cellar: :any_skip_relocation, sonoma:        "2dff23afc434c192d8a1300ce52149c45c8e78f1120a591725ebeed89a5ca2f9"
    sha256 cellar: :any_skip_relocation, ventura:       "2dff23afc434c192d8a1300ce52149c45c8e78f1120a591725ebeed89a5ca2f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8686e4c1ccf438ed8466938f9648aed0c49c4160999ed6c0f63c5b9719c72f5f"
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