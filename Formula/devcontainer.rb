require "language/node"

class Devcontainer < Formula
  desc "Reference implementation for the Development Containers specification"
  homepage "https://containers.dev"
  url "https://registry.npmjs.org/@devcontainers/cli/-/cli-0.37.0.tgz"
  sha256 "91faa34ab83dfd61a72361247816d434a026778806c795910f35343dae4ac591"
  license "MIT"

  bottle do
    sha256                               arm64_ventura:  "1efde6320ed002b6f051a8509b586c8d6cad73bc384f915f496f6502d3c7c073"
    sha256                               arm64_monterey: "b35d5d38c79ed3e7f80a29686f32f9f8f7073c5ff287ddeb56f8b1b9a7e414af"
    sha256                               arm64_big_sur:  "ceee391498b8f91e5fab4fd7c8e035fd6179c121365ee4d077a0450648b3f136"
    sha256                               ventura:        "bcc1643d6f73fdfa1478dcdc58d5b7ca7e26f81de40497ad45db48b1e26e325d"
    sha256                               monterey:       "c72d74ee29872b8a47fd8c26953d22f64ef8bf471ab3023de6f0deeb0263e5dc"
    sha256                               big_sur:        "846459f92f25305b419d9f32fbae1e982a61706780469ce0e66575eb04847fbe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "46bd1c950703180c29b11226234825faf4e3d2c28bf312ba4e8a0c6973faba04"
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