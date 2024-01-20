require "language/node"

class SnykCli < Formula
  desc "Scans and monitors projects for security vulnerabilities"
  homepage "https://snyk.io"
  url "https://registry.npmjs.org/snyk/-/snyk-1.1271.0.tgz"
  sha256 "d719a42852bf06fa5bb3e4238e18c25dd6a8cb1d17278722a3f7e43978a12a48"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a6ac2dd97053930796affb025601b08b0f3caf3634f9122b9d7af9ba6da23265"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eedcab36543ee37493f825dd1fa2500fd11f486a01ef29375511b5c10cbad685"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e3c744fe6df870c870d5d7e405e27fe4b408f8f004764d8c25b9fb9ee1e203d2"
    sha256 cellar: :any_skip_relocation, sonoma:         "c885867f7b7d3c303c235bfe068089621690c187c5a1eaec101859fb9766fe6a"
    sha256 cellar: :any_skip_relocation, ventura:        "673199e20063114f73f15fc3d12b47d26da8de769615d4c6297074bc065e7031"
    sha256 cellar: :any_skip_relocation, monterey:       "b1eae21825a48e9fb92d97eb95f4a0555dc4cca4306089d7596f578ba8a73e05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "14a7a2f8038fa34c23ed079d27a93becdf900f9ad71ad3a9c45a315a90315c9b"
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