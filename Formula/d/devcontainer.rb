require "language/node"

class Devcontainer < Formula
  desc "Reference implementation for the Development Containers specification"
  homepage "https://containers.dev"
  url "https://registry.npmjs.org/@devcontainers/cli/-/cli-0.51.1.tgz"
  sha256 "015cf62274667fad72fdc84da83bc03c9ba19cc46af270c6170195e9b3ccbe28"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bf12c62e9c8c6a050b10c1378449f53ceb8f6eecc292f81384574c5d79d8c679"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bf12c62e9c8c6a050b10c1378449f53ceb8f6eecc292f81384574c5d79d8c679"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bf12c62e9c8c6a050b10c1378449f53ceb8f6eecc292f81384574c5d79d8c679"
    sha256 cellar: :any_skip_relocation, ventura:        "5bf17e3e59e85d35a19aaa178f48da036159da885d60379c0999691b440d7278"
    sha256 cellar: :any_skip_relocation, monterey:       "5bf17e3e59e85d35a19aaa178f48da036159da885d60379c0999691b440d7278"
    sha256 cellar: :any_skip_relocation, big_sur:        "5bf17e3e59e85d35a19aaa178f48da036159da885d60379c0999691b440d7278"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "213a29b6290fe5a3ffee176a3e58c2b8586d0814cfb900cf77a0c4d9d3d69e52"
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