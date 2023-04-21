require "language/node"

class Devcontainer < Formula
  desc "Reference implementation for the Development Containers specification"
  homepage "https://containers.dev"
  url "https://registry.npmjs.org/@devcontainers/cli/-/cli-0.39.0.tgz"
  sha256 "d315e21f6da17a4d5ac2ba7a99b36f46f3bff1bde657f6bbc8aeca3217b61786"
  license "MIT"

  bottle do
    sha256                               arm64_ventura:  "cce48ca46c61eadf368c221455ac1fffe1edd0f99f22d50f929609e512899e2f"
    sha256                               arm64_monterey: "4b33f3d6613f5c41e2f3fa2fd4b287f38a954e8cf731fa3eff8429209cb73044"
    sha256                               arm64_big_sur:  "375c53ac99be3add373733ff6452ddee8695a0d27bb6abe10b66a4d463a8f029"
    sha256                               ventura:        "e748a8d6eef5bda5f1463ddb19660e187e6e7f8b6a48a8ae0f21ab146b9b803e"
    sha256                               monterey:       "2a1fef513ca0833424191ee2dba9fdfdf5d620364f1c126b119a305195d677bb"
    sha256                               big_sur:        "7173a320d7b6910ed3cf146d646838f2c96894dc2c3e3cb0d837e4b04fb4eb3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "753c9213721916182ff38d471d8454c59b05259bb6e110f570c96cb3282a3bb7"
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