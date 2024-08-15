class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.188.tgz"
  sha256 "c320fc05bee0511c45be733d802a3d6683081ecae6bb9344f0f44c8c62039cd3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "95f6d4bc29d163713e9d02fc589c114001356ddc5bde772a9d1b7ae252cc72bb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "95f6d4bc29d163713e9d02fc589c114001356ddc5bde772a9d1b7ae252cc72bb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "95f6d4bc29d163713e9d02fc589c114001356ddc5bde772a9d1b7ae252cc72bb"
    sha256 cellar: :any_skip_relocation, sonoma:         "862891d68583bb8e48a34a44ee62ac99f6d521e2ab38cefb6dabbc5a42a8bdae"
    sha256 cellar: :any_skip_relocation, ventura:        "862891d68583bb8e48a34a44ee62ac99f6d521e2ab38cefb6dabbc5a42a8bdae"
    sha256 cellar: :any_skip_relocation, monterey:       "862891d68583bb8e48a34a44ee62ac99f6d521e2ab38cefb6dabbc5a42a8bdae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "95f6d4bc29d163713e9d02fc589c114001356ddc5bde772a9d1b7ae252cc72bb"
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