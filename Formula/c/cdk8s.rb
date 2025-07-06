class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.200.121.tgz"
  sha256 "1aa1cb2fc8b4b6588d0e4b12ecfe7bafaadf6beba24aa6ee8dd8bf4aa1bfd7b6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "63a149a6626e89f566d496d04244beebe0cd87249bfe3d8f084153efb99ae774"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "63a149a6626e89f566d496d04244beebe0cd87249bfe3d8f084153efb99ae774"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "63a149a6626e89f566d496d04244beebe0cd87249bfe3d8f084153efb99ae774"
    sha256 cellar: :any_skip_relocation, sonoma:        "5f200581c3bb202cb0bbed83952e87a48d942a426651cdbf183c73142bf11340"
    sha256 cellar: :any_skip_relocation, ventura:       "5f200581c3bb202cb0bbed83952e87a48d942a426651cdbf183c73142bf11340"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "63a149a6626e89f566d496d04244beebe0cd87249bfe3d8f084153efb99ae774"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "63a149a6626e89f566d496d04244beebe0cd87249bfe3d8f084153efb99ae774"
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