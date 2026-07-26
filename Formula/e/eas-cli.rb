class EasCli < Formula
  desc "Command-line tool for working with Expo Application Services"
  homepage "https://docs.expo.dev/eas/"
  url "https://registry.npmjs.org/eas-cli/-/eas-cli-21.2.0.tgz"
  sha256 "67bb817ec99477389c2d649a22691bb105e96eca9b899c2da360872f0c57b5bc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d55d38570ec50949f26bb7fc5166de18e172a3decd856b412c857885ab038419"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/eas --version")
    assert_match "Run this command inside a project directory",
                 shell_output("#{bin}/eas diagnostics 2>&1", 1)
  end
end