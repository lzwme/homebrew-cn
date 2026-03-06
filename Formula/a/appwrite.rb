class Appwrite < Formula
  desc "Command-line tool for Appwrite"
  homepage "https://appwrite.io"
  url "https://registry.npmjs.org/appwrite-cli/-/appwrite-cli-14.0.1.tgz"
  sha256 "0d07ca405b311ef7a719c09bb10a478cf351ff9d22ecc763a618c9a026e6a058"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5badbe6341c662802092b9e42c9d8783d0b30570556c90c257d7924e978a492b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "773c1447431fed6ed9b1c61b6ff5929087c41c71c87700c0409b17bb2d038f14"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "773c1447431fed6ed9b1c61b6ff5929087c41c71c87700c0409b17bb2d038f14"
    sha256 cellar: :any_skip_relocation, sonoma:        "d500cba193197a3fe69988274d7138fe3c5809be4648c6add4c41c08f535edfa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0f01b52a85e4b96a956f8d186097fda3a799f93791a2be2aaee1d72f2b70fe28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0f01b52a85e4b96a956f8d186097fda3a799f93791a2be2aaee1d72f2b70fe28"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/appwrite-cli/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    output = shell_output("#{bin}/appwrite client --endpoint http://localhost/v1 2>&1", 1)
    assert_match "Error: Invalid endpoint", output

    assert_match version.to_s, shell_output("#{bin}/appwrite --version")
  end
end