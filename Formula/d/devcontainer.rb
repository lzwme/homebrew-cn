require "language/node"

class Devcontainer < Formula
  desc "Reference implementation for the Development Containers specification"
  homepage "https://containers.dev"
  url "https://registry.npmjs.org/@devcontainers/cli/-/cli-0.53.0.tgz"
  sha256 "8debe360ef9b36a386c85277d43ac1f3f496eba94bbad8806f3bfd8c1d357bb8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "40db30d85bb8536f5d6cf74ead482291ab0d3cbc5c903416519858a9ba182a81"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "40db30d85bb8536f5d6cf74ead482291ab0d3cbc5c903416519858a9ba182a81"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "40db30d85bb8536f5d6cf74ead482291ab0d3cbc5c903416519858a9ba182a81"
    sha256 cellar: :any_skip_relocation, sonoma:         "4e67f3423edf1f2eaf73f6db0c0be15b75af58693030e32cc6b6a7a37cf8539b"
    sha256 cellar: :any_skip_relocation, ventura:        "4e67f3423edf1f2eaf73f6db0c0be15b75af58693030e32cc6b6a7a37cf8539b"
    sha256 cellar: :any_skip_relocation, monterey:       "4e67f3423edf1f2eaf73f6db0c0be15b75af58693030e32cc6b6a7a37cf8539b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dc8da0016824658e2b960cf3a26021f1f23caedc512bc1b44cc43b15c6c8a5c9"
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