class Haraka < Formula
  desc "Fast, highly extensible, and event driven SMTP server"
  homepage "https://haraka.github.io/"
  url "https://registry.npmjs.org/Haraka/-/Haraka-3.1.7.tgz"
  sha256 "9e1ad1d9b49c5c8b78a25166e6dde3a7b4931a4bd29c098fdae786bd0e69192e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f7742f7fff43df57e2890b0b611e0c275fe9e48d4bd635c628a2c61df5b732fd"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/haraka --version")

    system bin/"haraka", "--install", testpath/"config"
    assert_path_exists testpath/"config/README"

    output = shell_output("#{bin}/haraka --list")
    assert_match "plugins/auth", output
  end
end