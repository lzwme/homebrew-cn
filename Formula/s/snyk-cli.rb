require "language/node"

class SnykCli < Formula
  desc "Scans and monitors projects for security vulnerabilities"
  homepage "https://snyk.io"
  url "https://registry.npmjs.org/snyk/-/snyk-1.1268.0.tgz"
  sha256 "dfe7b8b649db60c022f15640e3e4e3edd6f8de26492ed665957b8632671a37d5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ae0e1d7596f53f779e14acfe0953601f11b1cf22e5636fea6a827f0befe85a6b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "210bc45708841127b2627d41c7d259ceb398228423f65a3bcd554b0ad63ddc13"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "64d99fee6c7ce29a4ab76a3f9dad730425f87b213bfcda58d3c64d03509ceeb6"
    sha256 cellar: :any_skip_relocation, sonoma:         "d2307223f327bd7fd26fcd3521c6e211aae1d1402df7288e6195115e4401b196"
    sha256 cellar: :any_skip_relocation, ventura:        "916e638482e0307ac4ee628ab87660fc492cfd252e738675bba3fadba041cdda"
    sha256 cellar: :any_skip_relocation, monterey:       "cc6f2db8d8a9ba1269a41d1e353f55c6592bbc975bc1382dd951a70741e22943"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f5c9f306494a4c1d4f8a23cefcaff6d48daf543b6eae7b9f4dd0e9f244c8c204"
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