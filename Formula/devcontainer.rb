require "language/node"

class Devcontainer < Formula
  desc "Reference implementation for the Development Containers specification"
  homepage "https://containers.dev"
  url "https://registry.npmjs.org/@devcontainers/cli/-/cli-0.49.0.tgz"
  sha256 "73dc5373846f8f41dd502d82a2f39ec11061b81f7ce003c07de46d96fe5d4b3f"
  license "MIT"

  bottle do
    sha256                               arm64_ventura:  "91e74bcdcdf14c34dfcd901ef28fe39e42f39d98548df442a0d7a57ff5998ad8"
    sha256                               arm64_monterey: "fe9cbe7ab45f5a8e08a86b68d859d0afb315c21586b630ea0c5ec6ecdb1b81a3"
    sha256                               arm64_big_sur:  "09d5d9baf3bea2b96611ec74e0d171db64bc1c883cf14d13790e25bd91d0ac70"
    sha256                               ventura:        "e9c7f11fefa835f0c0de6e91c75b8c6fe9372bf2422bf6d9e79bbab2534b0227"
    sha256                               monterey:       "3ca85022693a1313558d78ffaa2c0f017cf9c856281120b0f03a06441d928436"
    sha256                               big_sur:        "9e33f68795dbff1a5ddad7bf25040052350ab362eaa36b89f12eedcbd28f790b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c5f970f60041c8adf643c90bd8ea9737f472d7e05ce156ea66d5e5a8160df645"
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