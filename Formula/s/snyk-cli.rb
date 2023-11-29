require "language/node"

class SnykCli < Formula
  desc "Scans and monitors projects for security vulnerabilities"
  homepage "https://snyk.io"
  url "https://registry.npmjs.org/snyk/-/snyk-1.1257.0.tgz"
  sha256 "9238152c4ee0a41a3eecaffa5d4fe2c49cfd16c5394d8091af5c2e268ebd04f1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cbe902b47f4031ca07748bf4e534624edf0b96e640c8d42798ba23f3bcf617cc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1c683d0e2e00d06e988abb88842abdec101900c4848e9797aef969499f08edd9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e697ee58bf80b362e9b97692be8f61e3905d6a92249302ebbe1f1ebd0a4542b9"
    sha256 cellar: :any_skip_relocation, sonoma:         "681f2e8e8e7d1de89290de16489e1afbf448dd9143b1f83e06acd1ffa0ae867b"
    sha256 cellar: :any_skip_relocation, ventura:        "aedc198b52099a4f05e9fe75127e931806dbe3c574af07e0d16c3c49f6982f54"
    sha256 cellar: :any_skip_relocation, monterey:       "1af29ee38bba720b4a55efb4d47dc7e63fa98ab02578d1ff331367bc46fe0ae3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "486a2e8e55d34bd56cfefa756106bd392254238ababa194a48c7b19f89985fa9"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/snyk version")

    output = shell_output("#{bin}/snyk auth homebrew", 2)
    assert_match "Authentication failed. Please check the API token on https://snyk.io", output
  end
end