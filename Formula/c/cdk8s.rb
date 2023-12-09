require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.5.tgz"
  sha256 "254564badfb5fec0b8a9ba1653d5f0083485c287c1373d12b2becb0dbe912932"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4e9d2f47492089f01219d1f7dd10182bde3f82b3bf48be85d4f797892439cf8c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4e9d2f47492089f01219d1f7dd10182bde3f82b3bf48be85d4f797892439cf8c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4e9d2f47492089f01219d1f7dd10182bde3f82b3bf48be85d4f797892439cf8c"
    sha256 cellar: :any_skip_relocation, sonoma:         "dde50cc17c86749ad2249a3af723e681811d06b91abfd2d469a93d88d8e79fac"
    sha256 cellar: :any_skip_relocation, ventura:        "dde50cc17c86749ad2249a3af723e681811d06b91abfd2d469a93d88d8e79fac"
    sha256 cellar: :any_skip_relocation, monterey:       "dde50cc17c86749ad2249a3af723e681811d06b91abfd2d469a93d88d8e79fac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4e9d2f47492089f01219d1f7dd10182bde3f82b3bf48be85d4f797892439cf8c"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "Cannot initialize a project in a non-empty directory",
      shell_output("#{bin}/cdk8s init python-app 2>&1", 1)
  end
end