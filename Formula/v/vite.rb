require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-5.2.10.tgz"
  sha256 "690225300498997b5fcd88d043717ebc12fef8bd861822de3556e2cfef68d07e"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "63d852b977d736b8132b0ba8277b62cbba2144ee99cafd59334e7f42911cd4e7"
    sha256 cellar: :any,                 arm64_ventura:  "63d852b977d736b8132b0ba8277b62cbba2144ee99cafd59334e7f42911cd4e7"
    sha256 cellar: :any,                 arm64_monterey: "63d852b977d736b8132b0ba8277b62cbba2144ee99cafd59334e7f42911cd4e7"
    sha256 cellar: :any,                 sonoma:         "53c1c72197756a3b0968ec640a6bb50db2cc89f8c6a91d9d1b522182e47df85d"
    sha256 cellar: :any,                 ventura:        "53c1c72197756a3b0968ec640a6bb50db2cc89f8c6a91d9d1b522182e47df85d"
    sha256 cellar: :any,                 monterey:       "53c1c72197756a3b0968ec640a6bb50db2cc89f8c6a91d9d1b522182e47df85d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "db76f395200d92cb5d3f49541dfebbb8823cdf90f9a0e50dbe611831b099de0a"
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