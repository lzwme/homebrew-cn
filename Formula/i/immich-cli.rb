class ImmichCli < Formula
  desc "Command-line interface for self-hosted photo manager Immich"
  homepage "https://immich.app/docs/features/command-line-interface"
  url "https://registry.npmjs.org/@immich/cli/-/cli-2.2.46.tgz"
  sha256 "5be2a22b9d4fe26cf35797ad3eaf4a7755a4113bbcce53c7450e83e08c89211d"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ffa858f688eb2d81fcf1b9f673835567847c82f9c8d431ef1498715b0e6f1a87"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output(bin/"immich --version")
    assert_match "No auth file exists. Please login first.", shell_output(bin/"immich server-info", 1)
  end
end