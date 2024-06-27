require "language/node"

class SnykCli < Formula
  desc "Scans and monitors projects for security vulnerabilities"
  homepage "https://snyk.io"
  url "https://registry.npmjs.org/snyk/-/snyk-1.1292.0.tgz"
  sha256 "950a316a4c980843aa3bed6a0cae3e0f61be26c55c89604e61a2296f77da9d08"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "42488907ae1e47c616d59babc9de6a17fdcc3ad78c70c247b9769f2cf79d2eaf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "96edf82584cbfd84fb8c3e4a7d98338eee71e82913be0d014316d40484878f93"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "42488907ae1e47c616d59babc9de6a17fdcc3ad78c70c247b9769f2cf79d2eaf"
    sha256 cellar: :any_skip_relocation, sonoma:         "3039d487302773d8a364f985c3bd6d6db89c7c277a3b86a2c0e8e3485b73ae33"
    sha256 cellar: :any_skip_relocation, ventura:        "3039d487302773d8a364f985c3bd6d6db89c7c277a3b86a2c0e8e3485b73ae33"
    sha256 cellar: :any_skip_relocation, monterey:       "3039d487302773d8a364f985c3bd6d6db89c7c277a3b86a2c0e8e3485b73ae33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6735786bf3412eb0fec80739ede0cedc8c7030abd049d8855ddeba0234ab59ee"
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