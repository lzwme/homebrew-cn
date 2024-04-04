require "language/node"

class SnykCli < Formula
  desc "Scans and monitors projects for security vulnerabilities"
  homepage "https://snyk.io"
  url "https://registry.npmjs.org/snyk/-/snyk-1.1286.3.tgz"
  sha256 "cc3f40f7bc3061795e6731464756efa617a3eff63b50306e744661a7d8bbf097"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6ed021f146d2d0eb46534b41b4310539a7a677826ab613e928b17e1be6d91f69"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8e6ad781464312164f7fa0580f6224454365ba839292d609c935cb91fc827cc1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "928f43de101e6594da33ece59501a273e7a3f46b5d685a194263850e92bfc9b7"
    sha256 cellar: :any_skip_relocation, sonoma:         "916e61e73e37b9da5dad01ea7f24db29f1e84dfa50012e5a363ab07ada56fdf1"
    sha256 cellar: :any_skip_relocation, ventura:        "123d1d850fafb182ddcbcb0ed3901b39cc5d01fb2e3e816d580ba88aa35c387f"
    sha256 cellar: :any_skip_relocation, monterey:       "ab73bf4011f3302a3d504550e02d114d808484a9a07a1d01b20851b4718b8273"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e8389add894cd92a4a033c1e9a5e257f62ceca1b612d4c508dbc487e3008ac20"
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