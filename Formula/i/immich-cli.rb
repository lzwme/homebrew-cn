class ImmichCli < Formula
  desc "Command-line interface for self-hosted photo manager Immich"
  homepage "https://immich.app/docs/features/command-line-interface"
  url "https://registry.npmjs.org/@immich/cli/-/cli-2.2.33.tgz"
  sha256 "125769dfae573c64117ccffd9063952bb54b788c5e879b43d32569d3061aa54c"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c54bee0afe43b4cea039888229048f358a61a2e1e1162f192a57baa8a314c9e5"
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