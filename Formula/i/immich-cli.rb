class ImmichCli < Formula
  desc "Command-line interface for self-hosted photo manager Immich"
  homepage "https://immich.app/docs/features/command-line-interface"
  url "https://registry.npmjs.org/@immich/cli/-/cli-2.2.51.tgz"
  sha256 "dfe998a58a4c748f733e6acd8b9b1527dd3a32487fa3423a00c2fc90d347c9bf"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "db5237461edf653bf2133f83e08f986dcf48c1be17912a7cf7bad60dd4c420d2"
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