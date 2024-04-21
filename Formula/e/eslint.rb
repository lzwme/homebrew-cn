require "language/node"

class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-9.1.0.tgz"
  sha256 "d56797ab681f34b89d756786f0414470c839765680381099a5972dfc09eeb164"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "13edd76984236b18516d631592639230d05c2e3c7fcdd57416b11babbb97940b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "13edd76984236b18516d631592639230d05c2e3c7fcdd57416b11babbb97940b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "13edd76984236b18516d631592639230d05c2e3c7fcdd57416b11babbb97940b"
    sha256 cellar: :any_skip_relocation, sonoma:         "32fe96ab1a91e193b210b8f99fe71562de1148ca768ceac3c0073c949e7871ec"
    sha256 cellar: :any_skip_relocation, ventura:        "32fe96ab1a91e193b210b8f99fe71562de1148ca768ceac3c0073c949e7871ec"
    sha256 cellar: :any_skip_relocation, monterey:       "32fe96ab1a91e193b210b8f99fe71562de1148ca768ceac3c0073c949e7871ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "13edd76984236b18516d631592639230d05c2e3c7fcdd57416b11babbb97940b"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    # https://eslint.org/docs/latest/use/configure/configuration-files#configuration-file
    (testpath/"eslint.config.js").write("{}") # minimal config
    (testpath/"syntax-error.js").write("{}}")

    # https://eslint.org/docs/user-guide/command-line-interface#exit-codes
    output = shell_output("#{bin}/eslint syntax-error.js", 1)
    assert_match "Unexpected token }", output
  end
end