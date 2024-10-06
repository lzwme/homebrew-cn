class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.237.tgz"
  sha256 "3f96813f61ae1dfd23dc8031e85e228bf25304770b61371ef8be66db6965599a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "726994f180c28338725303cdfb877aa0c8f926ef7837998f075583f091a1ebcb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "726994f180c28338725303cdfb877aa0c8f926ef7837998f075583f091a1ebcb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "726994f180c28338725303cdfb877aa0c8f926ef7837998f075583f091a1ebcb"
    sha256 cellar: :any_skip_relocation, sonoma:        "69ff507a38a45d6be7ee5e765f901ebfa545f187c2eea20b0db99e2416ea284a"
    sha256 cellar: :any_skip_relocation, ventura:       "69ff507a38a45d6be7ee5e765f901ebfa545f187c2eea20b0db99e2416ea284a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "726994f180c28338725303cdfb877aa0c8f926ef7837998f075583f091a1ebcb"
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