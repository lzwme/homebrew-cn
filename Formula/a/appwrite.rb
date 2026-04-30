class Appwrite < Formula
  desc "Command-line tool for Appwrite"
  homepage "https://appwrite.io"
  url "https://registry.npmjs.org/appwrite-cli/-/appwrite-cli-19.2.0.tgz"
  sha256 "82a0d9d2c47185b8979716897af12580a27024f0a4667c7384835a4ceb4f1db8"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1692686d19686ae464a6c7759d6692248d68ec1c0b521016a143c4a2081a50b7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6e88dc8ab2c4844f29bc17c201e71a30d6b4a7325b879db05e37b48ef9dcf958"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6e88dc8ab2c4844f29bc17c201e71a30d6b4a7325b879db05e37b48ef9dcf958"
    sha256 cellar: :any_skip_relocation, sonoma:        "b6d9e70fc9a461e18879c4b0d57598dbaf333ecb57682e3ddb4a20a694f7e334"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7a3b7ae4174041b51eea5a502609ded66c15172785259ea6aff4d69658b18573"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7a3b7ae4174041b51eea5a502609ded66c15172785259ea6aff4d69658b18573"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/appwrite-cli/node_modules"
    machos = %w[fsevents/fsevents.node app-path/main]
    machos.each { |macho| deuniversalize_machos node_modules/macho } if OS.mac?
  end

  test do
    output = shell_output("#{bin}/appwrite client --endpoint http://localhost/v1 2>&1", 1)
    assert_match "Error: Invalid endpoint", output

    assert_match version.to_s, shell_output("#{bin}/appwrite --version")
  end
end