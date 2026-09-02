class EasCli < Formula
  desc "Command-line tool for working with Expo Application Services"
  homepage "https://docs.expo.dev/eas/"
  url "https://registry.npmjs.org/eas-cli/-/eas-cli-23.2.0.tgz"
  sha256 "12571f86ccc0e4955a4265f9009bf4901cafa274174c2741dc2358c3d3bc7463"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d4aec3d142a026889140eddac8f0ce4c563baa62c90aca0227144842153f1c9a"
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