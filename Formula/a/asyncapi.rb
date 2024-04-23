require "languagenode"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https:github.comasyncapicli"
  url "https:registry.npmjs.org@asyncapicli-cli-1.9.0.tgz"
  sha256 "b7f0e980125b4335532d640e44a9366418646081749755bdc019dde3079c8453"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "53a01d02e9e4c9942ebe9e2cfc857a8f7c7840497391c02e2ddde07bce4d17fe"
    sha256 cellar: :any,                 arm64_ventura:  "53a01d02e9e4c9942ebe9e2cfc857a8f7c7840497391c02e2ddde07bce4d17fe"
    sha256 cellar: :any,                 arm64_monterey: "53a01d02e9e4c9942ebe9e2cfc857a8f7c7840497391c02e2ddde07bce4d17fe"
    sha256 cellar: :any,                 sonoma:         "4402dcbffdca3a7953df48c7612db7c9e5b7986f4f895d9811b3e927d14d7978"
    sha256 cellar: :any,                 ventura:        "4402dcbffdca3a7953df48c7612db7c9e5b7986f4f895d9811b3e927d14d7978"
    sha256 cellar: :any,                 monterey:       "4402dcbffdca3a7953df48c7612db7c9e5b7986f4f895d9811b3e927d14d7978"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c48cb874b312f1eac18647e777664080b02e26bb7ce2fe509178a5052e31963"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}bin*"]

    # Replace universal binaries with their native slices
    deuniversalize_machos
  end

  test do
    system bin"asyncapi", "new", "--file-name=asyncapi.yml", "--example=default-example.yaml", "--no-tty"
    assert_predicate testpath"asyncapi.yml", :exist?, "AsyncAPI file was not created"
  end
end