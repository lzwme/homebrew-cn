class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.200.151.tgz"
  sha256 "61e4e44827d2fa616b323540cdce6c30bc198dae220b1d6a1500fd5f6bf5a59a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c933213d3d6499db4e71228d9906a803cc04c56a3516349a303a4a27d5834f73"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c933213d3d6499db4e71228d9906a803cc04c56a3516349a303a4a27d5834f73"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c933213d3d6499db4e71228d9906a803cc04c56a3516349a303a4a27d5834f73"
    sha256 cellar: :any_skip_relocation, sonoma:        "8c194177208bddbf41089d32f8d5c8a8ba0029f7e48b7562b6e2e68ad493cbcc"
    sha256 cellar: :any_skip_relocation, ventura:       "8c194177208bddbf41089d32f8d5c8a8ba0029f7e48b7562b6e2e68ad493cbcc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c933213d3d6499db4e71228d9906a803cc04c56a3516349a303a4a27d5834f73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c933213d3d6499db4e71228d9906a803cc04c56a3516349a303a4a27d5834f73"
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