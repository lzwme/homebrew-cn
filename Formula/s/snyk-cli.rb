class SnykCli < Formula
  desc "Scans and monitors projects for security vulnerabilities"
  homepage "https://snyk.io"
  url "https://registry.npmjs.org/snyk/-/snyk-1.1294.3.tgz"
  sha256 "01a677c1f212ce3914b74eae5041c423a5f1e09a03e4bd1312176ac02934362a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0ec638ce3755a23615b9f55a20e4adbdc155f6f8008ea8e54a8396592c01ac40"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0ec638ce3755a23615b9f55a20e4adbdc155f6f8008ea8e54a8396592c01ac40"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0ec638ce3755a23615b9f55a20e4adbdc155f6f8008ea8e54a8396592c01ac40"
    sha256 cellar: :any_skip_relocation, sonoma:        "c79fc4e7f6e9deff49aca7b15380794d3f5e309c458741635edb1cdc493b2966"
    sha256 cellar: :any_skip_relocation, ventura:       "c79fc4e7f6e9deff49aca7b15380794d3f5e309c458741635edb1cdc493b2966"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "85ae867cdab8709d32d6db886c646d9af3b3478e9fcd40ee1bddbaec5988395a"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/snyk version")

    output = shell_output("#{bin}/snyk auth homebrew", 2)
    assert_match "authentication failed (timeout)", output
  end
end