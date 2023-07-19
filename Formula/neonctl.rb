require "language/node"

class Neonctl < Formula
  desc "Neon CLI tool"
  homepage "https://neon.tech/docs/reference/neon-cli"
  url "https://registry.npmjs.org/neonctl/-/neonctl-1.18.0.tgz"
  sha256 "370877f4362a763273d704046c68dfe3392545ae214e9c2d2fdfddb9fd680e5f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "25a2801211cb01c0ffe327b69fce7d6ddf5203d9db59f1495ef9ab63aee031b4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "25a2801211cb01c0ffe327b69fce7d6ddf5203d9db59f1495ef9ab63aee031b4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "25a2801211cb01c0ffe327b69fce7d6ddf5203d9db59f1495ef9ab63aee031b4"
    sha256 cellar: :any_skip_relocation, ventura:        "5fc289cda3cbdf358725701f2a94273a1386489f397193f2f8ed1d922912d8c4"
    sha256 cellar: :any_skip_relocation, monterey:       "5fc289cda3cbdf358725701f2a94273a1386489f397193f2f8ed1d922912d8c4"
    sha256 cellar: :any_skip_relocation, big_sur:        "5fc289cda3cbdf358725701f2a94273a1386489f397193f2f8ed1d922912d8c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "25a2801211cb01c0ffe327b69fce7d6ddf5203d9db59f1495ef9ab63aee031b4"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/neonctl --api-key DOES-NOT-EXIST projects create 2>&1", 1)
    assert_match("Authentication failed,", output)
  end
end