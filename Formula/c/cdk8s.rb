class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.205.tgz"
  sha256 "3ef30903639968fc0577e6ca22675d4395925c3179911608a2b22e9767d2a3b0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8464736433b6ac33bbad74a58166de9a9add22607343b4af085994ba9ec7a380"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8464736433b6ac33bbad74a58166de9a9add22607343b4af085994ba9ec7a380"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8464736433b6ac33bbad74a58166de9a9add22607343b4af085994ba9ec7a380"
    sha256 cellar: :any_skip_relocation, sonoma:         "2b8975492c4a450b3c4782bed329abcd01eb1620914ec1445985ecb851432f41"
    sha256 cellar: :any_skip_relocation, ventura:        "2b8975492c4a450b3c4782bed329abcd01eb1620914ec1445985ecb851432f41"
    sha256 cellar: :any_skip_relocation, monterey:       "2b8975492c4a450b3c4782bed329abcd01eb1620914ec1445985ecb851432f41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8464736433b6ac33bbad74a58166de9a9add22607343b4af085994ba9ec7a380"
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