require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.135.tgz"
  sha256 "71bcac9e94dc0b26b0183d1c72b3244629cf92c4e22181697af2decb78e0d333"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "be8a616188d5506cb215191a1fbd319c740821dad079c383f669066d4d8a34cf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "be8a616188d5506cb215191a1fbd319c740821dad079c383f669066d4d8a34cf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "be8a616188d5506cb215191a1fbd319c740821dad079c383f669066d4d8a34cf"
    sha256 cellar: :any_skip_relocation, sonoma:         "9a2896fc9dd7c0430785b44c02383edd5f706a03853f9b996789db3a7ba29c7a"
    sha256 cellar: :any_skip_relocation, ventura:        "9a2896fc9dd7c0430785b44c02383edd5f706a03853f9b996789db3a7ba29c7a"
    sha256 cellar: :any_skip_relocation, monterey:       "9a2896fc9dd7c0430785b44c02383edd5f706a03853f9b996789db3a7ba29c7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8bdfe587d08aa7a4ac1f19638b8649290c397b09964703f24991885b0e52af74"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/cdk8s init python-app 2>&1", 1)
    assert_match "Initializing a project from the python-app template", output
  end
end