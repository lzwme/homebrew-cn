class ImmichCli < Formula
  desc "Command-line interface for self-hosted photo manager Immich"
  homepage "https://immich.app/docs/features/command-line-interface"
  url "https://registry.npmjs.org/@immich/cli/-/cli-2.5.5.tgz"
  sha256 "f63da8f562fa5a869cb9b6e92ede9a0fa559bf0177507d15e86c26ab267e50df"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "802dd431c0821c35e408caf8265e9dcdd17f6b871206e9b004a1edd3f35868c4"
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