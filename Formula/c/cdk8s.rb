class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.200.75.tgz"
  sha256 "dbbefdaaf0f0412ed1b99ca84e62e89ba71c8bc5419758c4b3961665fd841131"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5267b075d55e65e972fac4551a6f791e6c83a9f28a12d1d86c1f32caab050bb8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5267b075d55e65e972fac4551a6f791e6c83a9f28a12d1d86c1f32caab050bb8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5267b075d55e65e972fac4551a6f791e6c83a9f28a12d1d86c1f32caab050bb8"
    sha256 cellar: :any_skip_relocation, sonoma:        "78f4c51268c8176b082e8a924eb70a92de79c3be6a1db4e7c4dc7291d51a3294"
    sha256 cellar: :any_skip_relocation, ventura:       "78f4c51268c8176b082e8a924eb70a92de79c3be6a1db4e7c4dc7291d51a3294"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5267b075d55e65e972fac4551a6f791e6c83a9f28a12d1d86c1f32caab050bb8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5267b075d55e65e972fac4551a6f791e6c83a9f28a12d1d86c1f32caab050bb8"
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