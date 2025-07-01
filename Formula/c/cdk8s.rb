class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.200.116.tgz"
  sha256 "5a354364fc48976ea9e444467fd55967422b6ede9a5735d81cabe3d37bd09c9e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3461be5e9e06132ac57630f102fa196fccdc86bfcd6bc82a8d1a5eb34059c251"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3461be5e9e06132ac57630f102fa196fccdc86bfcd6bc82a8d1a5eb34059c251"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3461be5e9e06132ac57630f102fa196fccdc86bfcd6bc82a8d1a5eb34059c251"
    sha256 cellar: :any_skip_relocation, sonoma:        "9abac0a09d6695a62f1be6c3020e0f9fd08c3bacb8e05bcc2e6a42a601921c27"
    sha256 cellar: :any_skip_relocation, ventura:       "9abac0a09d6695a62f1be6c3020e0f9fd08c3bacb8e05bcc2e6a42a601921c27"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3461be5e9e06132ac57630f102fa196fccdc86bfcd6bc82a8d1a5eb34059c251"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3461be5e9e06132ac57630f102fa196fccdc86bfcd6bc82a8d1a5eb34059c251"
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