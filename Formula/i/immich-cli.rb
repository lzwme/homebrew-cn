class ImmichCli < Formula
  desc "Command-line interface for self-hosted photo manager Immich"
  homepage "https://immich.app/docs/features/command-line-interface"
  url "https://registry.npmjs.org/@immich/cli/-/cli-3.2.1.tgz"
  sha256 "0e43cbaf8ab69299579ff4932f252d1abd69c2915d45f5cf6a15b5cdd3305a74"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8b36bfa526a5a96711cc25688990dd2cadd71ed4cab4144b49f36c63a1e031d5"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/immich --version")
    assert_match "No auth file exists. Please login first.", shell_output("#{bin}/immich server-info", 1)
  end
end