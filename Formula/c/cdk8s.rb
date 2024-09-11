class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.213.tgz"
  sha256 "500d7752a5f7147704715e226380090647e92aca7f20a844db36c0241e9c486c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "e6e4aa7e27e13096b448d18f1faa4f91fa080833ce2d791a719a846efeec1191"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5ddd50053072c4aa03bbd4964f423241cd243fd02afb4b412ebb9b9baf4856e2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5ddd50053072c4aa03bbd4964f423241cd243fd02afb4b412ebb9b9baf4856e2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5ddd50053072c4aa03bbd4964f423241cd243fd02afb4b412ebb9b9baf4856e2"
    sha256 cellar: :any_skip_relocation, sonoma:         "33d3c1882b2f14b85b5dda99e43447a914fc88da34e7d5489217e62e44ef2f25"
    sha256 cellar: :any_skip_relocation, ventura:        "33d3c1882b2f14b85b5dda99e43447a914fc88da34e7d5489217e62e44ef2f25"
    sha256 cellar: :any_skip_relocation, monterey:       "2ff7d53b9ac2740f81102a6466c896d0fab41d7972db2949f4367b2303b86cb3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5ddd50053072c4aa03bbd4964f423241cd243fd02afb4b412ebb9b9baf4856e2"
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