require "language/node"

class Devcontainer < Formula
  desc "Reference implementation for the Development Containers specification"
  homepage "https://containers.dev"
  url "https://registry.npmjs.org/@devcontainers/cli/-/cli-0.48.0.tgz"
  sha256 "46f7d367f3ec87bd796da15bf7010904d430742387bd0a65d13dd41e8693caca"
  license "MIT"

  bottle do
    sha256                               arm64_ventura:  "1462098805f9a409e3c10bf7c64e9b149dece550d1e06efc0bff095fd193f439"
    sha256                               arm64_monterey: "4af973c59aeb6c059680503ca6b8720d99275e370f720e9bb0340492d2c0b14b"
    sha256                               arm64_big_sur:  "e8748e945580abb491d8a639c6d96a70e3c70bf2b672c9de6d9a569322547465"
    sha256                               ventura:        "66d1f24f8d90ae6cd4e3b253fb460d548ac4a869e5bbff8da22de39260dbbad7"
    sha256                               monterey:       "d26fdb51b75e0061cf63ae707ee25910d06c2f6af9f7745581a6dca3d5e4ad4d"
    sha256                               big_sur:        "3008fc793ab2ac7b8a6c384713d176134c011dd8420bd3b6495b3eb1d6a73d9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4ccffb4d6748d93bf9ec73c1b1f141f4f39d9af9d4d1c121dd47a111703838ba"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    ENV["DOCKER_HOST"] = "/dev/null"
    # Modified .devcontainer/devcontainer.json from CLI example:
    # https://github.com/devcontainers/cli#try-out-the-cli
    (testpath/".devcontainer.json").write <<~EOS
      {
        "name": "devcontainer-homebrew-test",
        "image": "mcr.microsoft.com/devcontainers/rust:0-1-bullseye"
      }
    EOS
    output = shell_output("#{bin}/devcontainer up --workspace-folder .", 1)
    assert_match '{"outcome":"error","message":"', output
  end
end