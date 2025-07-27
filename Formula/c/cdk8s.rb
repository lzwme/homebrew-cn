class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.200.142.tgz"
  sha256 "b162df9455b0c00d8b34eab4db75c03b2a9ae4660859d0ce9d9afdb17b76e07f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b0aca7090b7497961749815beda4acb66fcba495298e5fad67e629a6fc21614c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b0aca7090b7497961749815beda4acb66fcba495298e5fad67e629a6fc21614c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b0aca7090b7497961749815beda4acb66fcba495298e5fad67e629a6fc21614c"
    sha256 cellar: :any_skip_relocation, sonoma:        "9e19dc964a949763c3f7c84017d98bc521a0c66bea68b52cc31cd50e232686d4"
    sha256 cellar: :any_skip_relocation, ventura:       "9e19dc964a949763c3f7c84017d98bc521a0c66bea68b52cc31cd50e232686d4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b0aca7090b7497961749815beda4acb66fcba495298e5fad67e629a6fc21614c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b0aca7090b7497961749815beda4acb66fcba495298e5fad67e629a6fc21614c"
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