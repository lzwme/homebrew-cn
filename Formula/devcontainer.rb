require "language/node"

class Devcontainer < Formula
  desc "Reference implementation for the Development Containers specification"
  homepage "https://containers.dev"
  url "https://registry.npmjs.org/@devcontainers/cli/-/cli-0.41.0.tgz"
  sha256 "ef0e0c5fd9a80d899952d7f23956a624231b95c9717fd906bd446bfd738f0b7b"
  license "MIT"

  bottle do
    sha256                               arm64_ventura:  "329a5edf6088d238b234f264e05df7e0534b93a559a43a5fd2e9df6c2c9b61dd"
    sha256                               arm64_monterey: "02e74499ca7e741987d6a871b7a07bb2283c6f49862e2ef16a3b940607152ef3"
    sha256                               arm64_big_sur:  "0f094d7f0b460fac13ef29d2732b62dcac91ce6e31a0ad7ad3ac2653aa823278"
    sha256                               ventura:        "7891d1d1b982f81d30f279e37e49eb3a68166a140e5833444ee528d7681e424b"
    sha256                               monterey:       "9f2d8571059e53e4c83c3237b4d204c5ae8cb846c561a5448d98992761a1ec69"
    sha256                               big_sur:        "061f73b2332b1cdb39e4e973d3561756ff295d35dce6eccfb936a16249615a6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e861d87dee58a20bab3f42c4350a644015392588d58abec7ece5f9b50c3f42b7"
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