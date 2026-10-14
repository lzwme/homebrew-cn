class EasCli < Formula
  desc "Command-line tool for working with Expo Application Services"
  homepage "https://docs.expo.dev/eas/"
  url "https://registry.npmjs.org/eas-cli/-/eas-cli-24.13.0.tgz"
  sha256 "0e5b5ef912ce08bed13d9ce0c217c274354a83e4844e37d83fa79f507f92e861"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e42e235c3d8adc7be4b388dcc09f34a4692ac63fd569e6a1e56fb11cc5e616a4"
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