class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.200.152.tgz"
  sha256 "b492d7accd970713781e5abdfcb9581577e72b8f4db2f963e5a0ba0711f1f11b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "402b69cebaf4b1ff4ca49596a9f8080b8b5d2242bd4bd3b2c88401e6e3878d4a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "402b69cebaf4b1ff4ca49596a9f8080b8b5d2242bd4bd3b2c88401e6e3878d4a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "402b69cebaf4b1ff4ca49596a9f8080b8b5d2242bd4bd3b2c88401e6e3878d4a"
    sha256 cellar: :any_skip_relocation, sonoma:        "f7bc3f21a89f861f2e228747b070446d7a684b6df59e0c881f1fe5f1a9be47d0"
    sha256 cellar: :any_skip_relocation, ventura:       "f7bc3f21a89f861f2e228747b070446d7a684b6df59e0c881f1fe5f1a9be47d0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "402b69cebaf4b1ff4ca49596a9f8080b8b5d2242bd4bd3b2c88401e6e3878d4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "402b69cebaf4b1ff4ca49596a9f8080b8b5d2242bd4bd3b2c88401e6e3878d4a"
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