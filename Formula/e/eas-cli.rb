class EasCli < Formula
  desc "Command-line tool for working with Expo Application Services"
  homepage "https://docs.expo.dev/eas/"
  url "https://registry.npmjs.org/eas-cli/-/eas-cli-20.1.0.tgz"
  sha256 "658c055798bc225fc08dc9338fa6dc83b6267381a6fe2f8cbf41018607b5d4e5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c214a719cb15018a390dcc2baf967736db6f672666e606b20727d565f19d11fe"
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