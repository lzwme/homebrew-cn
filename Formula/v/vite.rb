class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-8.0.13.tgz"
  sha256 "53d6694dc2e6b4a3cd5e1a5c0a7e19f5d7a4787b7e17607691a82ad84662f1d5"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "78d4b8bdeaeb6500a8f4efcfed4a67eb6a5100d5f86950b71bde179af32e081e"
    sha256 cellar: :any,                 arm64_sequoia: "424a919cc26fc69f0bea4d38de108667d9b3f3de27373d848d214cc73415e9d2"
    sha256 cellar: :any,                 arm64_sonoma:  "424a919cc26fc69f0bea4d38de108667d9b3f3de27373d848d214cc73415e9d2"
    sha256 cellar: :any,                 sonoma:        "3bbb323a885179f9ca0fc3ede821c86bbf188df8d7cb8e48f82d7dc91c69c364"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "564cce5a26add36c6d00e3fa0c21d109099aa1074211ae61028faad44a351a4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b6ff0f5def8c617b841087ba9d047fc5f38af562733e6c9b65703f7ddd4f35bb"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/vite/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    output = shell_output("#{bin}/vite optimize --force")
    assert_match "Forced re-optimization of dependencies", output

    output = shell_output("#{bin}/vite optimize")
    assert_match "Hash is consistent. Skipping.", output

    assert_match version.to_s, shell_output("#{bin}/vite --version")
  end
end