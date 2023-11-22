require "language/node"

class Devcontainer < Formula
  desc "Reference implementation for the Development Containers specification"
  homepage "https://containers.dev"
  url "https://registry.npmjs.org/@devcontainers/cli/-/cli-0.54.0.tgz"
  sha256 "d96a7ef107d74c88f660a614b0ed9885796ccb328e1bd7c8bedde0139f10283a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ed1d0588268f7faa3a3b8cbf1f5c9557af65ea64e7078c44a2231f43d727fe8f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ed1d0588268f7faa3a3b8cbf1f5c9557af65ea64e7078c44a2231f43d727fe8f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ed1d0588268f7faa3a3b8cbf1f5c9557af65ea64e7078c44a2231f43d727fe8f"
    sha256 cellar: :any_skip_relocation, sonoma:         "73b6ad5fbbcf68207c95e7c5c35fae546929339b3ab5b095031b75a5a0d4989f"
    sha256 cellar: :any_skip_relocation, ventura:        "73b6ad5fbbcf68207c95e7c5c35fae546929339b3ab5b095031b75a5a0d4989f"
    sha256 cellar: :any_skip_relocation, monterey:       "73b6ad5fbbcf68207c95e7c5c35fae546929339b3ab5b095031b75a5a0d4989f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed1d0588268f7faa3a3b8cbf1f5c9557af65ea64e7078c44a2231f43d727fe8f"
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