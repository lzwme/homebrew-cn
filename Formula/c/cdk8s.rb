class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https:cdk8s.io"
  url "https:registry.npmjs.orgcdk8s-cli-cdk8s-cli-2.198.303.tgz"
  sha256 "3e17989afcd2c3844138cb6ce3071e5041775a0f05e7171ee3694f733a87dcb7"
  license "Apache-2.0"
  head "https:github.comcdk8s-teamcdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3de2560c8047914f2482efd8b69c519b8d70d9b58e66d853635889c86d47a4f4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3de2560c8047914f2482efd8b69c519b8d70d9b58e66d853635889c86d47a4f4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3de2560c8047914f2482efd8b69c519b8d70d9b58e66d853635889c86d47a4f4"
    sha256 cellar: :any_skip_relocation, sonoma:        "dca725b2b2f6f5b83e2f7af4a20adb828ce29071a05352fc35c91a64868b47eb"
    sha256 cellar: :any_skip_relocation, ventura:       "dca725b2b2f6f5b83e2f7af4a20adb828ce29071a05352fc35c91a64868b47eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3de2560c8047914f2482efd8b69c519b8d70d9b58e66d853635889c86d47a4f4"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    output = shell_output("#{bin}cdk8s init python-app 2>&1", 1)
    assert_match "Initializing a project from the python-app template", output
  end
end