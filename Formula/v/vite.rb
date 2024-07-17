require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-5.3.4.tgz"
  sha256 "fda5bd1a3510263d69c0d4e5305afced2d89e177428b7c4bf45487862629c4db"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "9edd9736e41d1db3dec53c2cb873c07716efe54d47056c366a250226efca52a1"
    sha256 cellar: :any,                 arm64_ventura:  "9edd9736e41d1db3dec53c2cb873c07716efe54d47056c366a250226efca52a1"
    sha256 cellar: :any,                 arm64_monterey: "9edd9736e41d1db3dec53c2cb873c07716efe54d47056c366a250226efca52a1"
    sha256 cellar: :any,                 sonoma:         "68781461f08d798466187b167235f38c96a64435b5765be1a929fc379eeb331b"
    sha256 cellar: :any,                 ventura:        "68781461f08d798466187b167235f38c96a64435b5765be1a929fc379eeb331b"
    sha256 cellar: :any,                 monterey:       "67e992452302b3a9a220308a07d51d84f369c75eee31c60b564af3f8aafcf51d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "11f3a41e26c18be5ef48b2fb5d3ee8dedc616c623ad5347aeb8e8d6882e8f184"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/vite optimize --force")
    assert_match "Forced re-optimization of dependencies", output

    output = shell_output("#{bin}/vite optimize")
    assert_match "Hash is consistent. Skipping.", output

    assert_match version.to_s, shell_output("#{bin}/vite --version")
  end
end